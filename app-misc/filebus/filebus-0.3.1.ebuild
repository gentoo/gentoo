# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A user space multicast named pipe implementation backed by a regular file"
HOMEPAGE="https://github.com/zmedico/filebus"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+inotify python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		inotify? ( dev-python/watchdog[${PYTHON_USEDEP}] )
	)"
BDEPEND="${RDEPEND}"

src_prepare() {
	default
	if use python; then
		distutils-r1_src_prepare
	fi
}

src_compile() {
	if use python; then
		distutils-r1_src_compile
	fi
}

src_test() {
	"${BASH}" ./lib/bash/filebus-test.bash test || die

	if use python; then
		distutils-r1_src_test
	fi
}

python_test() {
	python test/test_filebus.py || die "tests failed for ${EPYTHON}"
}

src_install() {
	if use python; then
		distutils-r1_src_install
	else
		insinto /usr/libexec/filebus
		doins lib/bash/*.bash
		cat <<-EOF > "${T}/filebus"
		#!/bin/sh
		exec bash "${EPREFIX}/usr/libexec/filebus/filebus.bash" "\$@"
		EOF
		dobin "${T}/filebus"
	fi
}
