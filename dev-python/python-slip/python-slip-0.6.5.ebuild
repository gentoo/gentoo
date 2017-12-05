# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 eutils

DESCRIPTION="Miscellaneous convenience, extension and workaround code for Python"
HOMEPAGE="https://github.com/nphilipp/python-slip"
SRC_URI="https://github.com/nphilipp/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="dbus selinux"

RDEPEND="
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		sys-auth/polkit )
"
DEPEND=""

python_prepare_all() {
	use selinux || epatch "${FILESDIR}"/${PN}-0.6.5-no-selinux.patch

	# hard-disable slip.gtk since it did not get ported to gtk3+ and the only user
	# of slip (firewalld) does not use it (upstream disables it for py3 already)
	sed \
		-e 's|sys.version_info.major == 2|False|' \
		-e "s:@VERSION@:${PV}:" setup.py.in > setup.py || die "sed failed"

	if ! use dbus; then
		sed -e '/name="slip.dbus"/ s/\(.*\)/if 0:\n    \1/' \
			-i setup.py || die "sed 2 failed"
	fi

	distutils-r1_python_prepare_all
}
