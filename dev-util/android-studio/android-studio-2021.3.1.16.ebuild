# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

RESTRICT="bindist mirror strip"

QA_PREBUILT="
	opt/${PN}/bin/*
	opt/${PN}/jre/bin/*
	opt/${PN}/jre/lib/*
	opt/${PN}/jre/lib/jli/*
	opt/${PN}/jre/lib/server/*
	opt/${PN}/lib/pty4j-native/linux/*/*
	opt/${PN}/plugins/android/resources/installer/*/*
	opt/${PN}/plugins/android/resources/native/*
	opt/${PN}/plugins/android/resources/perfetto/*/*
	opt/${PN}/plugins/android/resources/simpleperf/*/*
	opt/${PN}/plugins/android/resources/trace_processor_daemon/*
	opt/${PN}/plugins/android/resources/transport/*/*
	opt/${PN}/plugins/android/resources/transport/native/agent/*/*
	opt/${PN}/plugins/android-ndk/resources/lldb/android/*/*
	opt/${PN}/plugins/android-ndk/resources/lldb/bin/*
	opt/${PN}/plugins/android-ndk/resources/lldb/lib/python3.9/lib-dynload/*
	opt/${PN}/plugins/android-ndk/resources/lldb/lib64/*
	opt/${PN}/plugins/design-tools/resources/layoutlib/data/linux/lib64/*
	opt/${PN}/plugins/c-clangd/bin/clang/linux/*
	opt/${PN}/plugins/webp/lib/libwebp/linux/*
"

DESCRIPTION="Android development environment based on IntelliJ IDEA"
HOMEPAGE="https://developer.android.com/studio"
SRC_URI="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${PV}/${P}-linux.tar.gz"
#SRC_URI="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${PV}/${PN}-${PV}-linux.tar.gz"

LICENSE="Apache-2.0 android BSD BSD-2 CDDL-1.1 CPL-0.5
	EPL-1.0 GPL-2 GPL-2+ JDOM IJG LGPL-2.1 MIT
	MPL-1.1 MPL-2.0 NPL-1.1 OFL ZLIB"

SLOT="0"
IUSE="selinux"
KEYWORDS="~amd64 ~x86"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-android )
	>=app-arch/bzip2-1.0.8-r3
	>=dev-libs/expat-2.4.8
	>=dev-libs/libffi-3.4.2-r2
	>=media-libs/fontconfig-2.14.0-r1
	>=media-libs/freetype-2.12.1-r1
	>=media-libs/libpng-1.6.37-r2
	>=media-libs/mesa-22.1.3[X(+)]
	|| ( gnome-extra/zenity kde-apps/kdialog x11-apps/xmessage x11-libs/libnotify )
	sys-libs/ncurses-compat:5[tinfo]
	>=sys-libs/zlib-1.2.12-r3
	>=x11-libs/libX11-1.8.1
	>=x11-libs/libXau-1.0.9-r1
	>=x11-libs/libXdamage-1.1.5
	>=x11-libs/libXdmcp-1.1.3-r1
	>=x11-libs/libXext-1.3.4
	>=x11-libs/libXfixes-6.0.0
	>=x11-libs/libXrender-0.9.10-r2
	>=x11-libs/libXxf86vm-1.1.4-r2
	>=x11-libs/libdrm-2.4.112
	>=x11-libs/libxcb-1.15-r1
	>=x11-libs/libxshmfence-1.3-r2
	virtual/libcrypt:=
"

S=${WORKDIR}/${PN}

src_compile() {
	:;
}

src_install() {
	local dir="/opt/${PN}"
	insinto "${dir}"
	doins -r *

	fperms 755 "${dir}"/bin/{fsnotifier,format.sh,game-tools.sh,inspect.sh,ltedit.sh,profiler.sh,studio.sh,printenv.py,restart.py}
	fperms -R 755 "${dir}"/bin/{helpers,lldb}
	fperms -R 755 "${dir}"/jre/bin
	fperms 755 "${dir}"/jre/lib/{jexec,jspawnhelper}
	fperms -R 755 "${dir}"/plugins/Kotlin/kotlinc/bin
	fperms -R 755 "${dir}"/plugins/android/resources/installer
	fperms -R 755 "${dir}"/plugins/android/resources/perfetto
	fperms -R 755 "${dir}"/plugins/android/resources/simpleperf
	fperms -R 755 "${dir}"/plugins/android/resources/trace_processor_daemon
	fperms -R 755 "${dir}"/plugins/android/resources/transport/{arm64-v8a,armeabi-v7a,x86,x86_64}
	fperms -R 755 "${dir}"/plugins/android-ndk/resources/lldb/{android,bin,lib,shared}
	fperms 755 "${dir}"/plugins/c-clangd/bin/clang/linux/{clang-tidy,clangd}
	fperms -R 755 "${dir}"/plugins/terminal/{,fish}
	fperms 755 "${dir}"/plugins/textmate/lib/bundles/git/src/{askpass-empty.sh,askpass.sh}

	newicon "bin/studio.png" "${PN}.png"
	make_wrapper ${PN} ${dir}/bin/studio.sh
	make_desktop_entry ${PN} "Android Studio" ${PN} "Development;IDE" "StartupWMClass=jetbrains-studio"
}

pkg_postrm() {
	elog "Android studio data files were not removed."
	elog "If there will be no other programs using them anymore"
	elog "(especially another flavor of Android Studio)"
	elog " remove manually following folders:"
	elog ""
	elog "		~/.android/"
	elog "		~/.config/Google/AndroidStudio*/"
	elog "		~/Android/"
	elog ""
	elog "Also, if there are no other programs using Gradle, remove:"
	elog ""
	elog "		~/.gradle/"
}
