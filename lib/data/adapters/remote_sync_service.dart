/// Placeholder for future REST synchronization.
/// Implementations can plug into repositories to send/receive data when connectivity is available.
abstract class RemoteSyncService {
  Future<void> pushPendingData();
  Future<void> pullReferenceData();
}
