https://github.com/dolphin-emu/dolphin/commit/22dc21cca42b2eaf373ac9e1b5128c566615aa71
https://github.com/dolphin-emu/dolphin/pull/13262

From 825092ad33a2e7466e79520c1338d0bed56ca299 Mon Sep 17 00:00:00 2001
From: Ferdinand Bachmann <ferdinand.bachmann@yrlf.at>
Date: Sat, 4 Jan 2025 18:45:32 +0100
Subject: [PATCH 1/2] BBA/HLE: Fix incorrect fmt format string

--- a/Source/Core/Core/HW/EXI/BBA/BuiltIn.cpp
+++ b/Source/Core/Core/HW/EXI/BBA/BuiltIn.cpp
@@ -686,7 +686,7 @@ bool CEXIETHERNET::BuiltInBBAInterface::SendFrame(const u8* frame, u32 size)
   }

   default:
-    ERROR_LOG_FMT(SP1, "Unsupported EtherType {#06x}", *ethertype);
+    ERROR_LOG_FMT(SP1, "Unsupported EtherType {:#06x}", *ethertype);
     return false;
   }


From b79bdb13c05b4fcef23cd30b210d40662d28373b Mon Sep 17 00:00:00 2001
From: Ferdinand Bachmann <ferdinand.bachmann@yrlf.at>
Date: Sat, 4 Jan 2025 18:46:04 +0100
Subject: [PATCH 2/2] Common: Fix compile failure with fmt>=11

--- a/Source/Core/Common/Logging/Log.h
+++ b/Source/Core/Common/Logging/Log.h
@@ -99,7 +99,13 @@ void GenericLogFmt(LogLevel level, LogType type, const char* file, int line, con
   static_assert(NumFields == sizeof...(args),
                 "Unexpected number of replacement fields in format string; did you pass too few or "
                 "too many arguments?");
-  GenericLogFmtImpl(level, type, file, line, format, fmt::make_format_args(args...));
+
+#if FMT_VERSION >= 110000
+  auto&& format_str = fmt::format_string<Args...>(format);
+#else
+  auto&& format_str = format;
+#endif
+  GenericLogFmtImpl(level, type, file, line, format_str, fmt::make_format_args(args...));
 }
 }  // namespace Common::Log

--- a/Source/Core/Common/MsgHandler.h
+++ b/Source/Core/Common/MsgHandler.h
@@ -41,12 +41,17 @@ bool MsgAlertFmt(bool yes_no, MsgType style, Common::Log::LogType log_type, cons
   static_assert(NumFields == sizeof...(args),
                 "Unexpected number of replacement fields in format string; did you pass too few or "
                 "too many arguments?");
-#if FMT_VERSION >= 90000
+#if FMT_VERSION >= 110000
+  static_assert(std::is_base_of_v<fmt::detail::compile_string, S>);
+  auto&& format_str = fmt::format_string<Args...>(format);
+#elif FMT_VERSION >= 90000
   static_assert(fmt::detail::is_compile_string<S>::value);
+  auto&& format_str = format;
 #else
   static_assert(fmt::is_compile_string<S>::value);
+  auto&& format_str = format;
 #endif
-  return MsgAlertFmtImpl(yes_no, style, log_type, file, line, format,
+  return MsgAlertFmtImpl(yes_no, style, log_type, file, line, format_str,
                          fmt::make_format_args(args...));
 }

@@ -60,7 +65,9 @@ bool MsgAlertFmtT(bool yes_no, MsgType style, Common::Log::LogType log_type, con
   static_assert(NumFields == sizeof...(args),
                 "Unexpected number of replacement fields in format string; did you pass too few or "
                 "too many arguments?");
-#if FMT_VERSION >= 90000
+#if FMT_VERSION >= 110000
+  static_assert(std::is_base_of_v<fmt::detail::compile_string, S>);
+#elif FMT_VERSION >= 90000
   static_assert(fmt::detail::is_compile_string<S>::value);
 #else
   static_assert(fmt::is_compile_string<S>::value);
