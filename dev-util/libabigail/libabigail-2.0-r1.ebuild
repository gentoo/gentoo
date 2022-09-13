# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools bash-completion-r1 python-any-r1 out-of-source

DESCRIPTION="Suite of tools for checking ABI differences between ELF objects"
HOMEPAGE="https://sourceware.org/libabigail/"
SRC_URI="https://mirrors.kernel.org/sourceware/libabigail/${P}.tar.gz"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/elfutils
	dev-libs/libxml2:2
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		sys-apps/texinfo
	)
	test? ( ${PYTHON_DEPS} )"

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

src_prepare() {
	default
	# need to run our autotools, due to ltmain.sh including Redhat calls:
	# cannot read spec file '/usr/lib/rpm/redhat/redhat-hardened-ld': No such file or directory
	eautoreconf
}

my_src_configure() {
	econf \
		--disable-deb \
		--disable-fedabipkgdiff \
		--disable-rpm \
		--disable-rpm415 \
		--disable-static \
		--enable-bash-completion \
		--enable-python3 \
		$(use_enable doc apidoc) \
		$(use_enable doc manual)
}

my_src_compile() {
	default
	use doc && emake doc
}

my_src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		doman doc/manuals/man/*
		doinfo doc/manuals/texinfo/abigail.info

		dodoc -r doc/manuals/html

		docinto html/api
		dodoc -r doc/api/html/.
	fi
}

my_src_install_all() {
	einstalldocs

	local file
	for file in abicompat abidiff abidw abilint abinilint abipkgdiff abisym fedabipkgdiff ; do
		dobashcomp bash-completion/${file}
	done

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
