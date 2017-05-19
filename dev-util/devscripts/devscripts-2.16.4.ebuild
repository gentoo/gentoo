# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5} )
DISTUTILS_OPTIONAL=true

inherit distutils-r1

DESCRIPTION="Scripts to make the life of a Debian Package maintainer easier"
HOMEPAGE="https://anonscm.debian.org/gitweb/?p=collab-maint/devscripts.git"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-lang/perl
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}
	app-arch/dpkg
	dev-util/debhelper
	sys-apps/fakeroot"

src_prepare() {
	default

	# Replace Debian xsl stylesheets paths with Gentoo's
	sed -i \
		-e 's#stylesheet/xsl/nwalsh#xsl-stylesheets#g' \
		"${S}"/po4a/Makefile \
		"${S}"/scripts/Makefile \
		"${S}"/scripts/deb-reversion.dbk || die

	sed -i "/python3 setup.py/d" "${S}"/scripts/Makefile || die

	# Avoid file collision with app-shells/bash-completion
	rm "${S}"/scripts/bts.bash_completion || die
}

src_configure() {
	default

	if use python; then
		pushd "${S}"/scripts > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		pushd "${S}"/scripts > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	dodir /usr/bin
	default

	if use python ;then
		pushd "${S}"/scripts > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}
