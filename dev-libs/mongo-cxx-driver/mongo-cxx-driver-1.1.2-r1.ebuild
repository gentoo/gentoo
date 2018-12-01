# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SCONS_MIN_VERSION=2.3.0

inherit scons-utils toolchain-funcs

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-cxx-driver"
SRC_URI="https://github.com/mongodb/${PN}/archive/legacy-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libressl sasl ssl static-libs"

RDEPEND="
	!dev-db/tokumx
	dev-libs/boost:=[threads(+)]
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

# Maintainer notes
# TODO: enable test in IUSE with
# test? ( >=dev-cpp/gtest-1.7.0 dev-db/mongodb )

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-fix-scons.patch
	"${FILESDIR}"/${PN}-1.1.2-boost-ref.patch
	"${FILESDIR}"/${PN}-1.1.2-boost-next.patch
)

S="${WORKDIR}/${PN}-legacy-${PV}"

src_configure() {
	scons_opts=(
		--cc=$(tc-getCC)
		--cxx=$(tc-getCXX)
		--cpppath="${EPREFIX}"/usr/include
		--libpath="${EPREFIX}"/usr/$(get_libdir)
		--variant-dir=build
		--disable-warnings-as-errors
		--sharedclient
	)

	use debug && scons_opts+=( --dbg=on )
	use sasl && scons_opts+=( --use-sasl-client )
	use ssl && scons_opts+=( --ssl )
}

src_compile() {
	escons "${scons_opts[@]}"
}

src_install() {
	escons "${scons_opts[@]}" install --prefix="${ED%/}"/usr

	# fix multilib-strict QA failures
	mv "${ED%/}"/usr/{lib,$(get_libdir)} || die

	einstalldocs

	if ! use static-libs; then
		find "${D}" -name '*.a' -delete || die
	fi
}
