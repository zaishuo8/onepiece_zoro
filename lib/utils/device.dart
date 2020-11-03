class DeviceInfo {
  final String phoneType;
  final String phoneOs;
  final String phoneOsVersion;

  const DeviceInfo({ this.phoneType, this.phoneOs, this.phoneOsVersion });
}

class DeviceUtil {
  static DeviceInfo getDeviceInfo() {
    return DeviceInfo(
        phoneOs: 'android',
        phoneType: 'HUAWEI HRY-AL00Ta',
        phoneOsVersion: '10.0.0'
    );
  }
}