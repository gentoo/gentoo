# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A highly efficient backup system based on the git packfile format"
HOMEPAGE="https://bup.github.io/ https://github.com/bup/bup"
SRC_URI="https://github.com/bup/bup/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc test web"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-arch/par2cmdline
	sys-libs/readline:0
	dev-vcs/git
	$(python_gen_cond_dep '
		dev-python/fuse-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pylibacl[${PYTHON_MULTI_USEDEP}]
		dev-python/pyxattr[${PYTHON_MULTI_USEDEP}]
		web? ( www-servers/tornado[${PYTHON_MULTI_USEDEP}] )
	')"
DEPEND="${RDEPEND}
	test? (
		dev-lang/perl
		net-misc/rsync
	)
	doc? ( app-text/pandoc )
"

# unresolved sandbox issues
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-sitedir.patch )

src_configure() {
	# only build/install docs if enabled
	export PANDOC=$(usex doc pandoc "")

	./configure || die
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr DOCDIR="/usr/share/${PF}" \
		SITEDIR="$(python_get_sitedir)" install
	python_fix_shebang "${ED}"
	python_optimize "${ED}"
}
