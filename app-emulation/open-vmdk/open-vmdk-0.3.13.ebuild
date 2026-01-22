# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )
inherit python-single-r1 toolchain-funcs

DESCRIPTION="Tools for creating and converting OVA virtual appliance files"
HOMEPAGE="https://github.com/vmware/open-vmdk"
SRC_URI="https://github.com/vmware/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="fuse +python test"
RESTRICT="!test? ( test )"
PROPERTIES="test_network fuse? ( test_privileged )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )
"

PYDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/libxml2[python,${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/xmltodict[${PYTHON_USEDEP}]
	')
"
DEPEND="
	virtual/zlib
	fuse? ( sys-fs/fuse:3= )
"
RDEPEND="
	${DEPEND}
	python? ( ${PYDEPEND} )
"
BDEPEND="
	fuse? ( virtual/pkgconfig )
	test? (
		fuse? ( sys-fs/e2fsprogs[fuse] )
		python? ( ${PYDEPEND} )
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
}

my_emake() {
	emake \
		"$(use python || echo DIRS='vmdk ova templates')" \
		PREFIX="${EPREFIX}/usr" \
		"${@}"
}

src_compile() {
	my_emake all $(usev fuse) CC="$(tc-getCC)"
}

src_test() {
	local ignore=()
	use python || ignore+=( pytest/test_*configs.py $(grep -Flr .py pytest) )
	use fuse || ignore+=( pytest/test_fuse.py )
	use fuse && addwrite /dev/fuse
	epytest "${ignore[@]/#/--ignore=}"
}

src_install() {
	my_emake install $(usex fuse install-fuse "") DESTDIR="${D}"
	use python && python_fix_shebang "${ED}"/usr/bin
}
