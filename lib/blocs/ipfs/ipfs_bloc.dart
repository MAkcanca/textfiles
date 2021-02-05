import 'dart:async';
import 'dart:isolate';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'package:meta/meta.dart';
import 'package:textfiles/models/textfile.dart';
import 'package:textfiles/services/shared_pref_service.dart';

part 'ipfs_event.dart';

part 'ipfs_state.dart';

class IpfsBloc extends Bloc<IpfsEvent, IpfsState> {
  IpfsBloc() : super(InitialIpfsState());
  static const platform = const MethodChannel('cambaz.textfiles/ipfs');

  @override
  Stream<IpfsState> mapEventToState(IpfsEvent event) async* {
    if (event is AppLaunched) {
      yield* mapAppLaunchedToState();
    }
    if (event is StartPeer) {
      yield* mapPeerStartToState();
    }
    if (event is FetchData) {
      yield* mapFetchDataToState(event.networkCid);
    }
    if (event is RetrieveData) {
      yield* mapRetrieveDataToState();
    }
    if (event is FetchFromGateway) {
      yield* mapFetchFromGatewayToState(event.networkCid);
    }
  }

  Stream<IpfsState> mapPeerStartToState() async* {
    try {
      final isStarted = await platform.invokeMethod('startPeer');
      if (isStarted) {
        yield PeerStarted();
      } else {
        yield PeerNotStarted();
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield PeerNotStarted();
    }
  }

  Stream<IpfsState> mapRetrieveDataToState() async* {
    String result;
    result = await platform.invokeMethod('getData');
    print(result);
    if (result != null) {
      yield Fetched(result);
    } else {
      yield FetchFailed();
    }
  }

  Stream<IpfsState> mapFetchFromGatewayToState(String networkCid) async* {
    String result;
    yield FetchInProgress();
    result = await getFromgateway(networkCid);
    print(result);
    if (result != null) {
      yield Fetched(result);
    } else {
      yield FetchFailed();
    }
  }


  Stream<IpfsState> mapFetchDataToState(String networkCid) async* {
    try {
      await platform.invokeMethod('startfetchData', {"cid": networkCid});
      yield FetchInProgress();
    } catch (_, stacktrace) {
      print(stacktrace);
      yield FetchFailed();
    }
  }

  Stream<IpfsState> mapAppLaunchedToState() async* {
    try {
      yield PeerNotStarted();
    } catch (_, stacktrace) {
      print(stacktrace);
      yield PeerNotStarted();
    }
  }
}
