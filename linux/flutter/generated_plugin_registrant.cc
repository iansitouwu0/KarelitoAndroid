//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dynamic_color/dynamic_color_plugin.h>
#include <flutter_bluetooth_classic_serial/flutter_bluetooth_classic_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dynamic_color_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DynamicColorPlugin");
  dynamic_color_plugin_register_with_registrar(dynamic_color_registrar);
  g_autoptr(FlPluginRegistrar) flutter_bluetooth_classic_serial_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterBluetoothClassicPlugin");
  flutter_bluetooth_classic_plugin_register_with_registrar(flutter_bluetooth_classic_serial_registrar);
}
