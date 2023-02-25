# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python{3_9,3_10,3_11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="check_multiple"
DESCRIPTION="A Nagios plugin to execute multiple checks in parallel"
HOMEPAGE="https://github.com/clarkbox/check_multiple"
SRC_URI="https://github.com/clarkbox/check_multiple/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	distutils-r1_src_install

	local nagiosplugindir="/usr/$(get_libdir)/nagios/plugins"
	dodir "${nagiosplugindir}"

	# Create a symlink from the nagios plugin directory to the /usr/bin
	# location. The "binary" in /usr/bin should also be a symlink, since
	# the python machinery allows the user to switch out the
	# interpreter. We don't want to mess with any of that, so we just
	# point to whatever the system would use if the user executed
	# ${MY_PN}.
	#
	# The relative symlink is preferred so that if the package is
	# installed e.g. while in a chroot, the symlink will never point
	# outside of that chroot.
	#
	dosym "../../../bin/${MY_PN}" "${nagiosplugindir}/${MY_PN}"
}

python_test() {
	"${EPYTHON}" -m unittest -v lib/check_multiple/check_multiple.py \
		|| die "test suite failed"
}
