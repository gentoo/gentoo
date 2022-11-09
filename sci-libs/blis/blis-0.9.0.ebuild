# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-any-r1

DESCRIPTION="BLAS-like Library Instantiation Software Framework"
HOMEPAGE="https://github.com/flame/blis"
SRC_URI="https://github.com/flame/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc eselect-ldso openmp pthread serial static-libs 64bit-index"
REQUIRED_USE="
	?? ( openmp pthread serial )
	?? ( eselect-ldso 64bit-index )"

DEPEND="
	eselect-ldso? (
		!app-eselect/eselect-cblas
		>=app-eselect/eselect-blas-0.2
	)"

RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-blas-provider.patch
	# to prevent QA Notice: pkg-config files with wrong LDFLAGS detected
	"${FILESDIR}"/${PN}-0.8.1-pkg-config.patch
	"${FILESDIR}"/${PN}-0.9.0-rpath.patch
)

src_configure() {
	local BLIS_FLAGS=()
	local confname
	# determine flags
	if use openmp; then
		BLIS_FLAGS+=( -t openmp )
	elif use pthread; then
		BLIS_FLAGS+=( -t pthreads )
	else
		BLIS_FLAGS+=( -t no )
	fi
	use 64bit-index && BLIS_FLAGS+=( -b 64 -i 64 )
	# determine config name
	case "${ARCH}" in
		"x86" | "amd64")
			confname=auto ;;
		"ppc64")
			confname=generic ;;
		*)
			confname=generic ;;
	esac
	# This is not an autotools configure file. We don't use econf here.
	./configure \
		--enable-verbose-make \
		--prefix="${BROOT}"/usr \
		--libdir="${BROOT}"/usr/$(get_libdir) \
		$(use_enable static-libs static) \
		--enable-blas \
		--enable-cblas \
		"${BLIS_FLAGS[@]}" \
		--enable-shared \
		$confname || die
}

src_compile() {
	DEB_LIBBLAS=libblas.so.3 DEB_LIBCBLAS=libcblas.so.3 \
		LDS_BLAS="${FILESDIR}"/blas.lds LDS_CBLAS="${FILESDIR}"/cblas.lds \
		default
}

src_test() {
	LD_LIBRARY_PATH="${S}/lib/haswell" emake check
}

src_install() {
	default
	use doc && dodoc README.md docs/*.md

	if use eselect-ldso; then
		insinto /usr/$(get_libdir)/blas/blis
		doins lib/*/lib{c,}blas.so.3
		dosym libblas.so.3 usr/$(get_libdir)/blas/blis/libblas.so
		dosym libcblas.so.3 usr/$(get_libdir)/blas/blis/libcblas.so
	fi
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="blis"

	# check blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect blas validate
}
