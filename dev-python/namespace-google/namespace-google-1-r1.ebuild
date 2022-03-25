# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{8..10} )
inherit python-r1

DESCRIPTION="Namespace package declaration for google"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	mkdir -p "${S}"/google || die
	cat > "${S}"/google/__init__.py <<-EOF || die
		__import__('pkg_resources').declare_namespace(__name__)
	EOF
}

src_install() {
	python_foreach_impl python_domodule google
}
