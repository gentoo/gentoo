# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-8-update7-linux"
inherit desktop font optfeature xdg

DESCRIPTION="Brainstorming and mind mapping software tool"
HOMEPAGE="https://www.xmind.net"
SRC_URI="http://dl2.xmind.net/xmind-downloads/${MY_P}.zip
	https://dev.gentoo.org/~creffett/distfiles/xmind-icons.tar.xz"
S="${WORKDIR}"

LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

BDEPEND="app-arch/unzip"
RDEPEND="
	>=virtual/jre-1.8
	x11-libs/gtk+:2
"

QA_PRESTRIPPED="opt/xmind/XMind/libcairo-swt.so"
QA_FLAGS_IGNORED="
	opt/xmind/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_1.1.400.v20160518-1444/eclipse_1617.so
	opt/xmind/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.400.v20160518-1444/eclipse_1617.so
	opt/xmind/XMind/XMind
"

FONT_SUFFIX="ttf"
FONT_S="${S}/fonts"

src_configure() {
	mv "XMind_$(usex amd64 amd64 i386)" XMind || die
	# force data instance & config area to be at home/.xmind directory
	sed \
		-e '/-configuration/d' \
		-e '/\.\/configuration/d' \
		-e '/-data/d' \
		-e '/\.\.\/Commons\/data\/workspace-cathy/d' \
		-e 's/\.\.\/plugins/\/opt\/xmind\/plugins/g' \
		-e '/-vmargs/i-showsplash' \
		-e '/vmargs/iorg.xmind.cathy' \
		-i XMind/XMind.ini || die
	echo '-Dosgi.instance.area=@user.home/.xmind/workspace-cathy' >> XMind/XMind.ini || die
	echo '-Dosgi.configuration.area=@user.home/.xmind/configuration-cathy' >> XMind/XMind.ini || die
}

src_compile() {
	:
}

src_install() {
	insinto /opt/xmind
	doins -r plugins configuration features XMind
	fperms a+rx  "/opt/xmind/XMind/XMind"

	exeinto /opt/bin
	newexe "${FILESDIR}/xmind-wrapper-3.7.0" xmind

	# install icons
	local res
	for res in 16 32 48; do
		newicon -s ${res} "${WORKDIR}/xmind-icons/xmind.${res}.png" xmind.png
	done

	make_desktop_entry ${PN} "XMind" ${PN} "Office" "MimeType=application/x-xmind;"
	font_src_install
}

pkg_postinst() {
	font_pkg_postinst
	xdg_pkg_postinst
	optfeature "audio notes support" media-sound/lame
}

pkg_postrm() {
	font_pkg_postrm
	xdg_pkg_postrm
}
