# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1 readme.gentoo-r1 systemd

GTEST_VER="1.8.1"
GTEST_URL="https://github.com/google/googletest/archive/${GTEST_VER}.tar.gz -> gtest-${GTEST_VER}.tar.gz"
DESCRIPTION="An advanced IRC Bouncer"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://github.com/znc/znc.git"}
	SRC_URI=""
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	SRC_URI="
		https://znc.in/releases/archive/${MY_P}.tar.gz
		test? ( ${GTEST_URL} )
	"
	KEYWORDS="amd64 arm arm64 x86"
	S=${WORKDIR}/${MY_P}
fi

HOMEPAGE="https://znc.in"
LICENSE="Apache-2.0"
# "If you upgrade your ZNC version, you must recompile all your modules."
# - https://wiki.znc.in/Compiling_modules
SLOT="0/${PV}"
IUSE="+ipv6 +icu nls perl python +ssl sasl tcl test +zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} icu )"

DEPEND="
	icu? ( dev-libs/icu:= )
	nls? ( dev-libs/boost:=[nls] )
	perl? ( >=dev-lang/perl-5.10:= )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( dev-libs/openssl:0= )
	tcl? ( dev-lang/tcl:0= )
	zlib? ( sys-libs/zlib:0= )
"
RDEPEND="
	${DEPEND}
	acct-user/znc
	acct-group/znc
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	perl? (
		>=dev-lang/swig-3.0.0
		>=dev-lang/perl-5.10
	)
	python? (
		>=dev-lang/swig-3.0.0
		>=dev-lang/perl-5.10
	)
	test? (
		${PYTHON_DEPS}
		dev-qt/qtnetwork:5
	)
"

PATCHES=( "${FILESDIR}"/${PN}-1.7.1-inttest-dir.patch )

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# Let SWIG rebuild modperl/modpython to make user patching easier.
	if [[ ${PV} != *9999* ]]; then
		rm modules/modperl/generated.tar.gz || die
		rm modules/modpython/generated.tar.gz || die
	fi

	sed -i -e "s|DZNC_BIN_DIR:path=|DZNC_BIN_DIR:path=${T}/inttest|" \
		test/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWANT_SYSTEMD=yes  # Causes -DSYSTEMD_DIR to be used.
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
	)

	if [[ ${PV} != *9999* ]] && use test; then
		export GTEST_ROOT="${WORKDIR}/googletest-release-${GTEST_VER}/googletest"
		export GMOCK_ROOT="${WORKDIR}/googletest-release-${GTEST_VER}/googlemock"
	fi

	cmake_src_configure
}

src_test() {
	cmake_build unittest
	DESTDIR="${T}/inttest" cmake_build install
	local filter='-'
	if ! use perl; then
		filter="${filter}:ZNCTest.Modperl*"
	fi
	if ! use python; then
		filter="${filter}:ZNCTest.Modpython*"
	fi
	# CMAKE_PREFIX_PATH and CXXFLAGS are needed for znc-buildmod
	# invocations from inside the test
	GTEST_FILTER="${filter}" ZNC_UNUSUAL_ROOT="${T}/inttest" \
		CMAKE_PREFIX_PATH="${T}/inttest/usr/share/znc/cmake" \
		CXXFLAGS="${CXXFLAGS} -isystem ${T}/inttest/usr/include" \
		cmake_build inttest
}

src_install() {
	cmake_src_install

	dodoc NOTICE
	newinitd "${FILESDIR}"/znc.initd-r2 znc
	newconfd "${FILESDIR}"/znc.confd-r1 znc

	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r1") || die
	DISABLE_AUTOFORMATTING=1
	readme.gentoo_create_doc
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		readme.gentoo_print_elog
	fi

	if [[ -d "${EROOT}"/etc/znc ]]; then
		ewarn "${EROOT}/etc/znc exists on your system."
		ewarn "Due to the nature of the contents of that folder,"
		ewarn "we have changed the default configuration to use"
		ewarn "	${EROOT}/var/lib/znc"
		ewarn "please move ${EROOT}/etc/znc to ${EROOT}/var/lib/znc"
		ewarn "or adjust your service configuration."
	fi
}

pkg_config() {
	if [[ -e "${EROOT}/var/lib/znc" ]]; then
		ewarn "${EROOT}/var/lib/znc already exists, aborting to avoid damaging"
		ewarn "any existing configuration. If you are sure you want"
		ewarn "to generate a new configuration, remove the folder"
		ewarn "and try again."
	else
		einfo "Press enter to interactively create a new configuration file for znc."
		einfo "To abort, press Control-C"
		read
		mkdir -p "${EROOT}/var/lib/znc" || die
		chown -R ${PN}:${PN} "${EROOT}/var/lib/znc" ||
			die "Setting permissions failed"
		start-stop-daemon --start --user ${PN}:${PN} --env ZNC_NO_LAUNCH_AFTER_MAKECONF=1 \
			"${EROOT}"/usr/bin/znc -- --makeconf --datadir "${EROOT}/var/lib/znc" ||
			die "Config failed"
		einfo
		einfo "You can now start the znc service using the init system of your choice."
		einfo "Don't forget to enable it if you want to use znc at boot."
	fi
}
