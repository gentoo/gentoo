# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7})

inherit python-single-r1

DESCRIPTION="Mailbox to quilt series converter"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/tglx/quilttools.git/about/"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/tglx/quilttools.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="dev-python/sphinx"
RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		net-mail/notmuch[python,${PYTHON_MULTI_USEDEP}]
	')"

src_compile() {
	emake -C Documentation man
	use doc && emake -C Documentation html
}

src_install() {
	dobin mb2q
	doman Documentation/output/man/mb2q.1
	python_fix_shebang "${ED}"

	local DOCS=( README.md )
	use doc && local HTML_DOCS=( Documentation/output/html/. )
	einstalldocs

	use examples && dodoc -r Documentation/examples
}
