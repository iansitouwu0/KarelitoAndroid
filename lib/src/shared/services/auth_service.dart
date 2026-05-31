import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/services.dart';

class AuthService {

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  // Obtener Usuario 
  static User? get currentUser => _auth.currentUser;

  // Verificar Inicio De Sesion Del Usuario
  static bool get isLoggedIn => currentUser != null;

  //Registarse con Correo y Contraseña
static Future<UserModel?> signUp({
  required String email,
  required String password,
  required String username,
  required UserRole role,
}) async {
  try {
    // 1. Crear Usuario de Autenticacion de Firebase
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) throw Exception('Creacion de Usuario Fallida');

    // 2. Modelo de Documento de Usurao en Firebase
    final userModel = UserModel(
      id: user.uid,
      email: email,
      username: username,
      role: role,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // ESTO CREA EL DOCUMENTO 
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toFirestore());

    // 3. Inicializare progreso
    await _initializeUserProgress(user.uid);

    return userModel;
  } on FirebaseAuthException catch (e) {
    throw _handleAuthException(e);
  }
}

  // Iniciar Sesion
  static Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Sign in failed');

      // Obtener Datos de Usuario desde Firebase
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Obtener Datos de Usuario desde Firestore
  static Future<UserModel?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Cerrar Sesion
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Manejar Excepciones de Autenticacion 
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La Contraseña es Debil.';
      case 'email-already-in-use':
        return 'Este Correo Ya Esta En Uso.';
      case 'invalid-email':
        return 'El Email Es Invalido.';
      case 'user-not-found':
        return 'No Existe Usuario con Este Email.';
      case 'wrong-password':
        return 'Contraseña Incorrecta.';
      default:
        return 'Ocurrio un Error: ${e.message}';
    }
  }

  static Future<void> _initializeUserProgress(String userId) async {
  try {
    // Crear Documento  de Progreso
    await _firestore
        .collection('levelProgress')
        .doc(userId)
        .set({
        'userId': userId,
        'createdAt': Timestamp.fromDate(DateTime.now()),
    });

    // Crear Clase Vacia de Progreso
    await _firestore
        .collection('classProgress')
        .doc(userId)
        .set({
        'userId': userId,
        'createdAt': Timestamp.fromDate(DateTime.now()),
    });

    PopupService.success('Colecciones de Progreso Inicializadas Para el Usuario $userId');
  } catch (e) {
    PopupService.error('Error Inicializando el Progeso : $e');
  }
  }
}