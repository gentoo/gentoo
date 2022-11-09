# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-single-r1 readme.gentoo-r1 systemd

GTEST_VER="1.8.1"
GTEST_URL="https://github.com/google/googletest/archive/${GTEST_VER}.tar.gz -> gtest-${GTEST_VER}.tar.gz"
DESCRIPTION="An advanced IRC Bouncer"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/znc/znc.git"
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	SRC_URI="
		https://znc.in/releases/archive/${MY_P}.tar.gz
		test? ( ${GTEST_URL} )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S=${WORKDIR}/${MY_P}
fi

HOMEPAGE="https://znc.in"
LICENSE="Apache-2.0"
# "If you upgrade your ZNC version, you must recompile all your modules."
# - https://wiki.znc.in/Compiling_modules
SLOT="0/${PV}"
IUSE="+icu nls perl python +ssl sasl tcl test +zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} icu )"

# perl is a build-time dependency of modpython
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	perl? (
		>=dev-lang/swig-4.0.1
		>=dev-lang/perl-5.10
	)
	python? (
		>=dev-lang/swig-4.0.1
		>=dev-lang/perl-5.10
	)
	test? (
		${PYTHON_DEPS}
		dev-qt/qtnetwork:5
	)
"
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

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-inttest-dir.patch
)

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

	sed -i "s|--datadir=|&${EPREFIX}|" znc.service.in || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWANT_SYSTEMD=yes  # Causes -DSYSTEMD_DIR to be used.
		-DSYSTEMD_DIR="$(systemd_get_systemunitdir)"
		-DWANT_ICU="$(usex icu)"
		-DWANT_IPV6=yes
		-DWANT_I18N="$(usex nls)"
		-DWANT_PERL="$(usex perl)"
		-DWANT_PYTHON="$(usex python)"
		-DWANT_PYTHON_VERSION="${EPYTHON#python}"
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

	local DOC_CONTENTS
	# "local" has its own return value which is not what we want to catch
	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r1") || die
	local DISABLE_AUTOFORMATTING=1
	readme.gentoo_create_doc
}

pkg_postinst() {
	if [[ -d "${EROOT}/var/lib/znc/.znc/" ]]; then
		eerror "${EROOT}/var/lib/znc/.znc/ exists, please move your data to ${EROOT}/var/lib/znc/"
		eerror ""
		eerror "The systemd unit has changed and now expects data to be located"
		eerror "at the root of ${EROOT}/var/lib/znc instead of its '.znc' subfolder."
		eerror "The recommended procedure to move the data is the following:"
		eerror "1. stop the service: systemctl stop znc.service"
		eerror "2. move the data: cp -a '${EROOT}/var/lib/znc/.znc/.' '${EROOT}/var/lib/znc/'"
		eerror "3. fix the config file: sed -i 's|${EROOT}/var/lib/znc/.znc|${EROOT}/var/lib/znc|g' '${EROOT}/var/lib/znc/configs/znc.conf'"
		eerror "4. restart znc: systemctl start znc.service"
		eerror "5. once everything works, remove the old data directory: rm -r '${EROOT}/var/lib/znc/.znc/'"
		eerror "See https://bugs.gentoo.org/743856 for details."
	fi

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		readme.gentoo_print_elog
	fi
}

pkg_config() {
	if [[ -d "${EROOT}/var/lib/znc/configs" ]]; then
		ewarn "${EROOT}/var/lib/znc/configs/ already exists,"
		ewarn "aborting to avoid damaging any existing configuration."
		ewarn "If you are sure you want to generate a new configuration,"
		ewarn "remove the folder and try again."
	else
		einfo "Press enter to interactively create a new configuration file for znc."
		einfo "To abort, press Control-C"
		read
		su ${PN} -p -s /bin/sh -c 'ZNC_NO_LAUNCH_AFTER_MAKECONF=1 \
			"${EROOT}"/usr/bin/znc --makeconf \
			--datadir "${EROOT}/var/lib/znc"' || die "Config failed"
		einfo
		einfo "You can now start the znc service using the init system of your choice."
		einfo "Don't forget to enable it if you want to use znc at boot."
	fi
}
