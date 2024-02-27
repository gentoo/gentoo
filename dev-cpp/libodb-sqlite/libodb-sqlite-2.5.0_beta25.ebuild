# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-$(ver_cut 1-3)-b.$(ver_cut 5)"

# Compare BUILD2_PV with the version in the tarball in the 'manifest' file.
# e.g. from 2.5.0_beta25's manifest:
# +depends: * build2 >= 0.15.0
# +depends: * bpkg >= 0.15.0
BUILD2_PN=build2-toolchain
BUILD2_PV="0.15.0"
BUILD2_P="${BUILD2_PN}-${BUILD2_PV}"

inherit toolchain-funcs multiprocessing

DESCRIPTION="Common ODB runtime library"
HOMEPAGE="https://codesynthesis.com/products/odb/"
SRC_URI="
	https://pkg.cppget.org/1/beta/odb/${MY_P}.tar.gz
	https://download.build2.org/${BUILD2_PV}/${BUILD2_P}.tar.xz
"
BS="${WORKDIR}/${BUILD2_P}"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( Code-Synthesis-ODB GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-cpp/libodb
	dev-db/sqlite:3
"
BDEPEND="virtual/pkgconfig"
RDEPEND="
	${DEPEND}
	!<dev-util/build2-${BUILD2_PV}
"

b() {
	local myargs=(
		--jobs $(makeopts_jobs)
		--verbose 3
	)
	export LD_LIBRARY_PATH="${BS}/libbutl/libbutl:${BS}/build2/libbuild2:${BS}/build2/libbuild2/bash:${BS}/build2/libbuild2/in:${BS}/build2/libbuild2/bin:${BS}/build2/libbuild2/c:${BS}/build2/libbuild2/cc:${BS}/build2/libbuild2/cxx:${BS}/build2/libbuild2/version:${BS}/libpkgconf/libpkgconf:${LD_LIBRARY_PATH}"
	set -- "${BS}"/build2/build2/b-boot "${@}" "${myargs[@]}"
	echo "${@}"
	"${@}" || die "${@} failed"
}

src_prepare() {
	cd "${WORKDIR}" || die
	for i in ${BUILD2_P}/libodb-sqlite/buildfile ${MY_P}/buildfile; do
		printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
			"-L${EPREFIX}/usr/$(get_libdir) $($(tc-getPKG_CONFIG) sqlite3 --libs)" \
			"$($(tc-getPKG_CONFIG) sqlite3 --cflags)" >> \
			${i} \
			|| die
	done

	cd "${BS}" || die
	eapply "${FILESDIR}"/build2-0.13.0_alpha0_pre20200710-nousrlocal.patch
	sed \
		-e 's:libsqlite3[/]\?::' \
		-i buildfile build/bootstrap.build \
		|| die

	if has_version dev-util/pkgconf; then
		for i in build2/build2/buildfile build2/libbuild2/buildfile; do
			printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
				"$($(tc-getPKG_CONFIG) libpkgconf --libs)" \
				"$($(tc-getPKG_CONFIG) libpkgconf --cflags)" >> \
				"${i}" \
				|| die
		done
		sed \
			-e 's:libpkgconf[/]\?::' \
			-i buildfile build/bootstrap.build \
			|| die
	fi

	cd "${S}" || die
	default
}

src_configure() {
	pushd ${BS} || die
	emake -C build2 -f bootstrap.gmake \
		CXX=$(tc-getCXX) \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
	popd || die

	b configure \
		config.cxx="$(tc-getCXX)" \
		config.cxx.coptions="${CXXFLAGS}" \
		config.cxx.loptions="${LDFLAGS}" \
		config.c="$(tc-getCC)" \
		config.cc.coptions="${CFLAGS}" \
		config.cc.loptions="${LDFLAGS}" \
		config.bin.ar="$(tc-getAR)" \
		config.bin.ranlib="$(tc-getRANLIB)" \
		config.bin.lib=shared \
		config.install.root="${EPREFIX}"/usr \
		config.install.lib="${EPREFIX}"/usr/$(get_libdir) \
		config.install.doc="${EPREFIX}"/usr/share/doc/${PF}
}

src_compile() {
	b update-for-install
	use test && b update-for-test
}

src_test() {
	b test
}

src_install() {
	b install \
		config.install.chroot="${D}"
}
