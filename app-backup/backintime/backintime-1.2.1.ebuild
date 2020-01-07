# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1 xdg

DESCRIPTION="Backup system inspired by TimeVault and FlyBack"
HOMEPAGE="https://backintime.readthedocs.io/en/latest/ https://github.com/bit-team/backintime/"
SRC_URI="https://github.com/bit-team/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples qt5"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	net-misc/openssh
	net-misc/rsync[xattr,acl]
"
RDEPEND="${DEPEND}
	qt5? ( dev-python/PyQt5[gui,widgets] )
"

PATCHES=( "${FILESDIR}/${P}-no-compress-docs-examples.patch" )

src_configure() {
	pushd common > /dev/null || die
		./configure --python3 --no-fuse-group || die
	popd > /dev/null || die
	if use qt5 ; then
		pushd qt > /dev/null || die
			./configure --python3 || die
		popd > /dev/null || die
	fi
}

src_compile() {
	pushd common > /dev/null || die
		emake
	popd > /dev/null || die
	if use qt5 ; then
		pushd qt > /dev/null || die
			emake
		popd > /dev/null || die
	fi
}

src_install() {
	pushd common > /dev/null || die
		emake DESTDIR="${D}" install
	popd > /dev/null || die
	if use qt5 ; then
		pushd qt > /dev/null || die
			emake DESTDIR="${D}" install
		popd > /dev/null || die
	fi

	einstalldocs
	if use examples ; then
		docinto examples
		dodoc common/{config-example-local,config-example-ssh}
	fi

	python_optimize "${D}"
}
