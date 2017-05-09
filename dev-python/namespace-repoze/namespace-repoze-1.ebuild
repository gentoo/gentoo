# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( pypy python{2_7,3_{4,5,6}}  )
inherit python-r1

DESCRIPTION="Namespace package declaration for repoze"
HOMEPAGE=""
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
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
