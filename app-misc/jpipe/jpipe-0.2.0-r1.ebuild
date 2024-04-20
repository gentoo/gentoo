# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GO_OPTIONAL=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit go-module distutils-r1 pypi

DESCRIPTION="Command line interface to JMESPath"
HOMEPAGE="https://github.com/pipebus/jpipe https://github.com/jmespath/jp/pull/30 http://jmespath.org"
SRC_URI+="
	!python? ( https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz )
"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT+=" test"
IUSE="jpp-symlink jp-symlink python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"
BDEPEND="${DISTUTILS_DEPS}
	!python? (
		app-arch/unzip
		>=dev-lang/go-1.12
	)
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	jpp-symlink? ( !app-misc/jp[jpp(-)] )
	jp-symlink? ( !app-misc/jp[jp(+)] )
	python? (
		${PYTHON_DEPS}
		dev-python/jmespath[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_unpack() {
	if use python; then
		default
	else
		go-module_src_unpack
	fi
}

src_prepare() {
	default
	if use python; then
		distutils-r1_src_prepare
	fi
}

python_prepare_all() {
	if ! use jpp-symlink; then
		sed -e '/"jpp = jpipe/d' -i setup.py || die
	fi
	if ! use jp-symlink; then
		sed -e '/"jp = jpipe/d' -i setup.py || die
	fi
	sed -e 's:entry_points()\["console_scripts"\]:entry_points().select(group="console_scripts"):' \
		-i lib/python/jpipe/cmd/main.py || die
	distutils-r1_python_prepare_all
}

src_configure() {
	if use python; then
		distutils-r1_src_configure
	else
		default
	fi
}

src_compile() {
	if use python; then
		distutils-r1_src_compile
	else
		go build -mod=readonly -o ./jpipe-jp ./lib/go/cmd/jp/main.go || die
		go build -mod=readonly -o ./jpipe-jpp ./lib/go/cmd/jpp/main.go || die
		go build -mod=readonly -o ./jpipe ./lib/go/cmd/jpipe/main.go || die
	fi
}

src_test() {
	use python && distutils-r1_src_test
}

python_test() {
	"${PYTHON}" test/test_jp.py || die "jp tests failed for ${EPYTHON}"
	"${PYTHON}" test/test_jpp.py || die "jpp tests failed for ${EPYTHON}"
}

src_install() {
	if use python; then
		distutils-r1_src_install
	else
		dobin jpipe jpipe-jp jpipe-jpp
		if use jpp-symlink; then
			dosym jpipe-jpp /usr/bin/jpp
		fi
		if use jp-symlink; then
			dosym jpipe-jp /usr/bin/jp
		fi
	fi
	dodoc README.md
}
