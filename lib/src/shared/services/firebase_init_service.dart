import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitService {
  static final _firestore = FirebaseFirestore.instance;
  static Future<void> initializeFirebase() async {
    try {
      debugPrint('Iniciando Firebase...');
      final isFirstLaunch = await _isFirstLaunch();

      if (isFirstLaunch) {
        debugPrint('Primera Compilacion. Inicializando colecciones...');
        await _createRootCollections();

        await _markInitialized();

        debugPrint('Inicializacion de firebase completada!');
      }
    } catch (e) {
      debugPrint('Error en la inicializacion de Firebase: $e');
      rethrow;
    }
  }
  static Future<bool> _isFirstLaunch() async {
    try {
      final initDoc = await _firestore
          .collection('_app_metadata')
          .doc('init_status')
          .get();

      return !initDoc.exists;
    } catch (e) {
      return true;
    }
  }

  static Future<void> _createRootCollections() async {
    try {
      await _firestore
          .collection('users')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('levels')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('classes')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('homeworks')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('levelProgress')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      await _firestore
          .collection('classProgress')
          .doc('_placeholder')
          .set({
        'placeholder': true,
        'createdAt': Timestamp.now(),
      });

      debugPrint('Colecciones Iniciales Creadas');
    } catch (e) {
      debugPrint('Error Creando Colecciones Iniciales: $e');
    }
  }
  static Future<void> _markInitialized() async {
    try {
      await _firestore
          .collection('_app_metadata')
          .doc('init_status')
          .set({
        'initialized': true,
        'initializationDate': Timestamp.now(),
        'appVersion': '1.0.0',
      });

      debugPrint('Inicializacion Marcada Como Completada');
    } catch (e) {
      debugPrint('Error Marcando Inicializacion: $e');
    }
  }
  static Future<void> cleanupPlaceholders() async {
    try {
      await _firestore.collection('users').doc('_placeholder').delete();
      await _firestore.collection('levels').doc('_placeholder').delete();
      await _firestore.collection('classes').doc('_placeholder').delete();
      await _firestore.collection('homeworks').doc('_placeholder').delete();
      await _firestore.collection('levelProgress').doc('_placeholder').delete();
      await _firestore
          .collection('classProgress')
          .doc('_placeholder')
          .delete();

      debugPrint('Documentos Base Limpiados');
    } catch (e) {
      debugPrint('Error Limpiando Documentos Base: $e');
    }
  }
}