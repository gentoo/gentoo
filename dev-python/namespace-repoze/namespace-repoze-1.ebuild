# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
inherit python-r1

DESCRIPTION="Namespace package declaration for repoze"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Python/Namespace_packages"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	mkdir -p "${S}"/repoze || die
	cat > "${S}"/repoze/__init__.py <<-EOF || die
		__import__('pkg_resources').declare_namespace(__name__)
	EOF
}

src_install() {
	python_foreach_impl python_domodule repoze
}
