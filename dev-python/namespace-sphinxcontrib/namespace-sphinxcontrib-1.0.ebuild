# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7}} )
inherit python-r1

DESCRIPTION="Namespace package declaration for sphinxcontrib"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

MODNAME=${PN#namespace-}

src_unpack() {
	mkdir -p "${S}"/${MODNAME} || die
	cat > "${S}"/${MODNAME}/__init__.py <<-EOF || die
		__import__('pkg_resources').declare_namespace(__name__)
	EOF
}

src_install() {
	python_foreach_impl python_domodule ${MODNAME}
}
