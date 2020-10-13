# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="A ZNC module which provides push notifications to Palaver"
HOMEPAGE="https://github.com/cocodelabs/znc-palaver"
SRC_URI="https://github.com/cocodelabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	net-irc/znc:=[ssl]"

BDEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/semantic_version[${PYTHON_USEDEP}]
	')
"

DOCS=( "CHANGELOG.md" "README.md" )

PATCHES=(
	"${FILESDIR}/${P}-python310.patch"
	"${FILESDIR}/${P}-xunit2.patch"
)

src_compile() {
	tc-export CXX

	# Building znc modules by 'znc-buildmod'
	# does not support multiple threads.
	emake -j1
}

src_test() {
	default

	emake test-integration
}

src_install() {
	insinto /usr/$(get_libdir)/znc
	doins palaver.so

	einstalldocs
}
