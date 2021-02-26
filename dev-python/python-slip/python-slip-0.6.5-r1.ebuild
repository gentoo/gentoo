# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Miscellaneous convenience, extension and workaround code for Python"
HOMEPAGE="https://github.com/nphilipp/python-slip"
SRC_URI="https://github.com/nphilipp/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 x86"
IUSE="dbus selinux"

RDEPEND="
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		sys-auth/polkit
	)
"

python_prepare_all() {
	use selinux || eapply -p1 "${FILESDIR}"/${PN}-0.6.5-no-selinux.patch

	# Disable gtk interface since it's gtk-2.
	sed \
		-e 's|sys.version_info.major == 2|False|' \
		-e "s:@VERSION@:${PV}:" setup.py.in > setup.py || die

	# Enable / disable dbus support by user choice.
	if ! use dbus; then
		sed -e '/name="slip.dbus"/ s/\(.*\)/if 0:\n    \1/' \
			-i setup.py || die
	fi

	distutils-r1_python_prepare_all
}
