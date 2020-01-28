# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GENTOO_DEPEND_ON_PERL=no
PYTHON_COMPAT=( python2_7 )
inherit autotools perl-module python-single-r1 toolchain-funcs

DESCRIPTION="Nagios/Icinga event broker that allows quick/direct access to your status data"
HOMEPAGE="https://checkmk.com/"
SRC_URI="https://checkmk.com/support/${PV/_}/${P/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="boost examples nagios4 perl python re2 test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	!sys-apps/ucspi-unix:0
	net-analyzer/rrdtool:=
	boost? ( dev-libs/boost )
	perl? (
		dev-lang/perl:0
		virtual/perl-Digest-MD5:0
		virtual/perl-Scalar-List-Utils:0
		>=virtual/perl-Thread-Queue-2.11:0
		virtual/perl-Encode:0
		dev-perl/JSON-XS:0
	)
	python? ( ${PYTHON_DEPS} )
	re2? ( dev-libs/re2:= )
"
DEPEND="
	${RDEPEND}
	perl? (
		dev-perl/Module-Install:0
		virtual/perl-ExtUtils-MakeMaker:0
		virtual/perl-File-Path:0
		virtual/perl-File-Spec:0
		virtual/perl-File-Temp:0
		test? (
			dev-perl/File-Copy-Recursive:0
			dev-perl/Test-Pod:0
			dev-perl/Test-Perl-Critic:0
			dev-perl/Test-Pod-Coverage:0
			dev-perl/Perl-Critic:0
			dev-perl/Perl-Critic-Policy-Dynamic-NoIndirect:0
			dev-perl/Perl-Critic-Deprecated:0
			dev-perl/Perl-Critic-Nits:0
		)
	)
"

PATCHES=(
	"${FILESDIR}"/1.2.8_p10-MINOR-test-Remove-the-usage-of-Perl-Critic-Policy-Mo.patch
	"${FILESDIR}"/${PN}-1.5.0_p22-rm.patch
)
S=${WORKDIR}/${P/_}

src_prepare() {
	default

	# Use system Module::Install instead, it will be copied to $S by
	# Module::install itself.
	rm -rf api/perl/inc || die

	# failing test
	rm -rf api/perl/t/20-Monitoring-Livestatus-test_socket.t || die

	if use perl; then
		# Ensure patches are not applied twice
		unset PATCHES
		perl-module_src_prepare
	fi

	eautoreconf
}

src_configure() {
	tc-export CC CXX

	econf \
		$(use_with boost boost-asio) \
		$(use_with nagios4) \
		$(use_with re2)

	if use perl; then
		cd api/perl || die
		perl-module_src_configure
	fi
}

src_compile() {
	default

	if use perl; then
		cd api/perl || die
		perl-module_src_compile
	fi
}

src_test() {
	if use perl; then
		cd api/perl || die

		SRC_TEST="parallel"
		export TEST_AUTHOR="Test Author"
		perl-module_src_test
	fi
}

src_install() {
	default

	rm "${ED}"/usr/$(get_libdir)/${PN}/liblivestatus.a || die

	# install a config file showing whats needed to enable livestatus for nagios
	cat <<EOF >"${T}"/nagios.cfg
# Ensure all data is set to event brokers
event_broker_options=-1
broker_module=${EPREFIX}/usr/$(get_libdir)/${PN}/livestatus.o
EOF
	# same for icinga
	cat <<EOF >"${T}"/icinga.cfg
define module{
        module_name             ${PN}
        module_type             neb
        path                    /usr/$(get_libdir)/${PN}/livestatus.o
        args                    /var/lib/icinga/rw/live
        }
EOF
	insinto /usr/share/${PN}
	doins "${T}"/{nagios,icinga}.cfg

	if use perl; then
		cd api/perl || die
		perl-module_src_install
		cd "${S}"

		if use examples; then
			docinto /
			newdoc api/perl/README README.perl

			docinto examples
			dodoc api/perl/examples/dump.pl
		fi
	fi

	if use python; then
		python_domodule api/python/livestatus.py

		if use examples; then
			docinto /
			newdoc api/python/README README.python

			docinto examples
			dodoc api/python/{example,example_multisite,make_nagvis_map}.py
		fi
	fi
}

pkg_postinst() {
	elog "Sample configurations for icinga and nagios are available in"
	elog "/usr/share/${PN}"
}
