# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_OPTIONAL=true

inherit distutils-r1

DESCRIPTION="Provides information about the Debian distributions' releases"
HOMEPAGE="https://debian.org"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="dev-lang/perl:=
	python? ( ${PYTHON_DEPS} )"
DEPEND="${COMMON_DEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	test? (
		dev-util/shunit2
		dev-python/pylint[${PYTHON_USEDEP}]
	)"
RDEPEND="${COMMON_DEPEND}
	dev-util/distro-info-data"

src_prepare() {
	default

	# 1. Gentoo do not provides dpkg vendor information
	# 2. Strip *FLAGS
	# 3. Strip predefined CFLAGS
	# 4. Point to correct perl's vendorlib
	# 5. Remove python tests - python eclass will be used instead
	sed -e "/cd python && python/d" \
		-e "/VENDOR/d" \
		-e "/dpkg-buildflags/d" \
		-e "s/-g -O2//g" \
		-e "s:\$(PREFIX)/share/perl5/Debian:\$(PERL_VENDORLIB)/Debian:g" \
		-e "/pyversions/d" \
		-i "${S}"/Makefile || die
}

src_configure() {
	default

	if use python; then
		pushd ./python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		pushd ./python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	emake PERL_VENDORLIB=$(perl -e 'require Config; print "$Config::Config{'vendorlib'}\n";' || die) \
		DESTDIR="${D}" install

	if use python; then
		pushd ./python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}

src_test() {
	TZ=UTC default

	if use python; then
		python_test() {
			esetup.py test
		}

		pushd ./python > /dev/null || die
		distutils-r1_src_test
		popd > /dev/null || die
	fi
}
