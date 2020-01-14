import 'package:meta/meta.dart';
import 'package:pixez/models/user_preview.dart';
import 'package:pixez/page/search/result/painter/bloc/bloc.dart';

@immutable
abstract class ResultPainterState {}
  
class InitialResultPainterState extends ResultPainterState {}
class  ResultPainterDataState extends ResultPainterState {
  final List<UserPreviews> userPreviews;
  final String nextUrl;
  ResultPainterDataState(this.userPreviews, this.nextUrl);
}
class  LoadEndState extends ResultPainterState{
  
}