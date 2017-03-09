# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils fdo-mime multilib python-single-r1

MY_P_AMD64="${P}-linux-x86_64"
MY_P_X86="${P}-linux-i486"

DESCRIPTION="Research management tool for desktop and web"
HOMEPAGE="http://www.mendeley.com/"
SRC_URI="
	amd64? ( ${MY_P_AMD64}.tar.bz2 )
	x86? ( ${MY_P_X86}.tar.bz2 )
	amd64-linux? ( ${MY_P_AMD64}.tar.bz2 )
	x86-linux? ( ${MY_P_X86}.tar.bz2 )"

LICENSE="Mendeley-terms"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="fetch"

DEPEND=""
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwebkit:5
	dev-qt/qtxml:5
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	${PYTHON_DEPS}"

QA_PREBUILT="/opt/mendeleydesktop/.*"

pkg_nofetch() {
	elog "Please download ${A} from:"
	elog "http://www.mendeley.com/download-mendeley-desktop/"
	elog "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}" || die

	if use amd64 || use amd64-linux ; then
		mv -f "${MY_P_AMD64}" "${P}" || die
	else
		mv -f "${MY_P_X86}" "${P}" || die
	fi
}

src_prepare() {
	# remove bundled Qt libraries
	rm -r lib/mendeleydesktop/plugins \
		|| die "failed to remove plugin directory"
	rm -r lib/qt || die "failed to remove qt libraries"

	# force use of system Qt libraries
	sed -i "s:sys\.argv\.count(\"--force-system-qt\") > 0:True:" \
		bin/mendeleydesktop || die "failed to patch startup script"

	# fix library paths
	sed -i \
		-e "s:lib/mendeleydesktop:$(get_libdir)/mendeleydesktop:g" \
		-e "s:MENDELEY_BASE_PATH + \"/lib/\":MENDELEY_BASE_PATH + \"/$(get_libdir)/\":g" \
		bin/mendeleydesktop || die "failed to patch library path"

	default
}

src_install() {
	# install menu
	domenu share/applications/${PN}.desktop

	# install application icons
	insinto /usr/share/icons
	doins -r share/icons/hicolor

	# install default icon
	insinto /usr/share/pixmaps
	doins share/icons/hicolor/48x48/apps/${PN}.png

	# install documentation, but no license file
	dodoc share/doc/${PN}/Readme.txt

	# install binary
	python_fix_shebang bin/${PN}
	into /opt/${PN}
	dobin bin/*

	# install libraries
	dolib.so lib/lib*.so*

	# install programs
	exeinto /opt/mendeleydesktop/$(get_libdir)/mendeleydesktop/libexec
	doexe lib/mendeleydesktop/libexec/*

	# install shared files
	insinto /opt/${PN}/share
	doins -r share/mendeleydesktop

	# install launch script
	into /opt
	make_wrapper ${PN} "/opt/${PN}/bin/${PN} --unix-distro-build"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
