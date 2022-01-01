# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="64a2db402f5e"
MY_PN=build2-toolchain
MY_P="${MY_PN}-$(ver_cut 1-3)-a.$(ver_cut 5).$(ver_cut 7).${COMMIT}"

inherit toolchain-funcs multiprocessing
SRC_URI="https://stage.build2.org/0/$(ver_cut 1-3)-a.$(ver_cut 5)/${MY_P}.tar.xz"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="cross-platform toolchain for building and packaging C++ code"
HOMEPAGE="https://build2.org"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.0_alpha0_pre20200710-nousrlocal.patch
)

S="${WORKDIR}/${MY_P}"

b() {
	local myargs=(
		--jobs $(makeopts_jobs)
		--verbose 3
	)
	export LD_LIBRARY_PATH="${S}/libbutl/libbutl:${S}/build2/libbuild2:${S}/build2/libbuild2/bash:${S}/build2/libbuild2/in:${S}/build2/libbuild2/bin:${S}/build2/libbuild2/c:${S}/build2/libbuild2/cc:${S}/build2/libbuild2/cxx:${S}/build2/libbuild2/version:${S}/libpkgconf/libpkgconf:${LD_LIBRARY_PATH}"
	set -- "${S}"/build2/build2/b-boot "${@}" "${myargs[@]}"
	echo "${@}"
	"${@}" || die "${@} failed"
}

src_prepare() {
	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"-L${EPREFIX}/usr/$(get_libdir) $($(tc-getPKG_CONFIG) sqlite3 --libs)" \
		"$($(tc-getPKG_CONFIG) sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile \
		|| die
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

	default
}

src_configure() {
	emake -C build2 -f bootstrap.gmake \
		CXX=$(tc-getCXX) \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"

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
		config.install.chroot="${D}" \
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
	b install
	mkdir -p "${ED}"/usr/share/doc/${PF}/html || die
	mv -f "${ED}"/usr/share/doc/${PF}/*.xhtml "${ED}"/usr/share/doc/${PF}/html || die
}
