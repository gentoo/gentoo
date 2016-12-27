# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
PLOCALES="ru"
CMAKE_MAKEFILE_GENERATOR=ninja

inherit cmake-utils l10n python-single-r1 readme.gentoo-r1 systemd user

GTEST_VER="1.8.0"
GTEST_URL="https://github.com/google/googletest/archive/release-${GTEST_VER}.tar.gz -> googletest-release-${GTEST_VER}.tar.gz"
DESCRIPTION="An advanced IRC Bouncer"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://github.com/znc/znc.git"}
	SRC_URI=""
	SWIG_DEPEND="
		perl? ( >=dev-lang/swig-3.0.0 )
		python? ( >=dev-lang/swig-3.0.0 )
	"
else
	SRC_URI="
		http://znc.in/releases/archive/${P}.tar.gz
		test? ( ${GTEST_URL} )
	"
	KEYWORDS="~amd64 ~arm ~x86"
	SWIG_DEPEND=""
fi

HOMEPAGE="http://znc.in"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="daemon +ipv6 +icu libressl nls perl python +ssl sasl tcl test +zlib"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} icu )"

RDEPEND="
	icu? ( dev-libs/icu:= )
	nls? ( dev-libs/boost[nls] )
	perl? ( >=dev-lang/perl-5.10:= )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	tcl? ( dev-lang/tcl:0= )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
	${SWIG_DEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	if use daemon; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
		# The home directory was previously set to /dev/null
		# This caused a bug with the systemd unit
		# https://bugs.gentoo.org/521916
		esethome ${PN} /var/lib/${PN}
	fi
}

src_prepare() {
	l10n_find_plocales_changes "${S}/src/po" "${PN}." '.po'
	remove_locale() {
		# Some languages can miss some modules
		rm src/po/${PN}.${1}.po modules/po/*.${1}.po || true
	}
	l10n_for_each_disabled_locale_do remove_locale
	cmake-utils_src_prepare
}

src_configure() {
	local want_swig
	if [[ ${PV} == *9999* ]]; then
		want_swig=yes
	else
		want_swig=no
	fi
	local mycmakeargs=(
		-DWANT_SYSTEMD="$(usex daemon)"
		-DSYSTEMD_DIR="$(systemd_get_systemunitdir)"
		-DWANT_ICU="$(usex icu)"
		-DWANT_IPV6="$(usex ipv6)"
		-DWANT_I18N="$(usex nls)"
		-DWANT_PERL="$(usex perl)"
		-DWANT_PYTHON="$(usex python)"
		-DWANT_CYRUS="$(usex sasl)"
		-DWANT_OPENSSL="$(usex ssl)"
		-DWANT_TCL="$(usex tcl)"
		-DWANT_ZLIB="$(usex zlib)"
		-DWANT_SWIG="${want_swig}"
	)
	if use test; then
		export GTEST_ROOT="${WORKDIR}/googletest-release-${GTEST_VER}/googletest"
		export GMOCK_ROOT="${WORKDIR}/googletest-release-${GTEST_VER}/googlemock"
	fi
	cmake-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	${CMAKE_MAKEFILE_GENERATOR} unittest || die "Unit test failed"
	popd > /dev/null || die
}

src_install() {
	cmake-utils_src_install
	dodoc NOTICE
	if use daemon; then
		newinitd "${FILESDIR}"/znc.initd-r2 znc
		newconfd "${FILESDIR}"/znc.confd-r1 znc
	fi
	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo") || die
	DISABLE_AUTOFORMATTING=1
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if [[ -d "${EROOT%/}"/etc/znc ]]; then
		ewarn "/etc/znc exists on your system."
		ewarn "Due to the nature of the contents of that folder,"
		ewarn "we have changed the default configuration to use"
		ewarn "	/var/lib/znc"
		ewarn "please move /etc/znc to /var/lib/znc"
		ewarn "or adjust /etc/conf.d/znc"
	fi
}

pkg_config() {
	if use daemon; then
		if [[ -e "${EROOT%/}/var/lib/znc" ]]; then
			ewarn "${EROOT%/}/var/lib/znc already exists, aborting to avoid damaging"
			ewarn "any existing configuration. If you are sure you want"
			ewarn "to generate a new configuration, remove the folder"
			ewarn "and try again."
		else
			einfo "Press any key to interactively create a new configuration file"
			einfo "for znc."
			einfo "To abort, press Control-C"
			read
			mkdir -p "${EROOT%/}/var/lib/znc" || die
			chown -R ${PN}:${PN} "${EROOT%/}/var/lib/znc" ||
				die "Setting permissions failed"
			start-stop-daemon --start --user ${PN}:${PN} --env ZNC_NO_LAUNCH_AFTER_MAKECONF=1 \
				"${EROOT%/}"/usr/bin/znc -- --makeconf --datadir "${EROOT%/}/var/lib/znc" ||
				die "Config failed"
			echo
			einfo "To start znc, run '/etc/init.d/znc start'"
			einfo "or add znc to a runlevel:"
			einfo "  rc-update add znc default"
		fi
	else
		ewarn "To configure znc as a system-wide daemon you have to"
		ewarn "enable the 'daemon' use flag."
	fi
}
