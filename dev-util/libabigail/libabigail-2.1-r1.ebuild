# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-libabigail-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
LIBABIGAIL_DOCS_PREBUILT=${LIBABIGAIL_DOCS_PREBUILT:=1}
LIBABIGAIL_DOCS_PREBUILT_DEV=sam
LIBABIGAIL_DOCS_VERSION="${PV}"
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
# bug #830088
LIBABIGAIL_DOCS_USEFLAG="+doc"

PYTHON_COMPAT=( python3_{8..11} )

inherit autotools bash-completion-r1 python-any-r1 out-of-source

DESCRIPTION="Suite of tools for checking ABI differences between ELF objects"
HOMEPAGE="https://sourceware.org/libabigail/"
SRC_URI="https://mirrors.kernel.org/sourceware/libabigail/${P}.tar.gz"
if [[ ${LIBABIGAIL_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !doc? ( https://dev.gentoo.org/~${LIBABIGAIL_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${LIBABIGAIL_DOCS_VERSION}-docs.tar.xz )"
	LIBABIGAIL_DOCS_USEFLAG="doc"
fi

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE="${LIBABIGAIL_DOCS_USEFLAG} test"
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
		--disable-ctf \
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

	# If USE=doc, there'll be newly generated docs which we install instead.
	if ! use doc && [[ ${LIBABIGAIL_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${LIBABIGAIL_DOCS_VERSION}-docs/docs/*.[0-8]
	elif use doc; then
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

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}
