# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit python-r1

MY_P=${PF/docutils-/}

DESCRIPTION="Gentoo GLEP support for docutils"
HOMEPAGE="https://www.gentoo.org/proj/en/glep/"
SRC_URI="mirror://gentoo/${MY_P}.tbz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/docutils-0.10[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# It's easier to move them around now.
	# TODO: add python_newmodule?
	mkdir {readers,transforms,writers} || die
	mv {glepread,readers/glep}.py || die
	mv {glepstrans,transforms/gleps}.py || die
	mv glep_html writers/ || die
}

src_install() {
	inst() {
		python_doscript glep.py

		python_moduleinto docutils
		python_domodule readers transforms writers
	}

	python_foreach_impl inst
}
