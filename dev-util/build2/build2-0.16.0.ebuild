# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=build2-toolchain
MY_P="${MY_PN}-${PV}"

inherit toolchain-funcs multiprocessing

DESCRIPTION="Cross-platform toolchain for building and packaging C++ code"
HOMEPAGE="https://build2.org"
SRC_URI="https://download.build2.org/${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	~dev-cpp/libodb-2.5.0_beta25
	~dev-cpp/libodb-sqlite-2.5.0_beta25
	dev-db/sqlite:3
"
BDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.0-update-for-install.patch
)

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
	# Unbundle dev-cpp/libodb and dev-cpp/libodb-sqlite
	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"-L${EPREFIX}/usr/$(get_libdir) $($(tc-getPKG_CONFIG) sqlite3 --libs)" \
		"$($(tc-getPKG_CONFIG) sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile \
		|| die
	sed -i \
		-e 's:libsqlite3[/]\?::' \
		buildfile build/bootstrap.build \
		|| die
	for i in build2/build2/buildfile build2/libbuild2/buildfile; do
		printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
			   "$($(tc-getPKG_CONFIG) libodb --libs)" \
			   "$($(tc-getPKG_CONFIG) libodb --cflags)" >> \
			   "${i}" \
			|| die
		printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
			   "$($(tc-getPKG_CONFIG) libodb-sqlite --libs)" \
			   "$($(tc-getPKG_CONFIG) libodb-sqlite --cflags)" >> \
			   "${i}" \
			|| die
	done
	sed -i \
		-e 's:libodb-sqlite[/]\?::' \
		-e 's:libodb[/]\?::' \
		buildfile build/bootstrap.build \
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
	b install: build2/ bpkg/ bdep/ libbuild2-kconfig/ \
		config.install.chroot="${D}"
	rm -rf "${ED}"/usr/include/odb \
	   "${ED}"/usr/include/pkgconf/libpkgconf \
		|| die
	rm -f "${ED}"/usr/include/sqlite3.h \
	   "${ED}"/usr/include/sqlite3ext.h \
	   "${ED}"/usr/$(get_libdir)/libodb.so \
	   "${ED}"/usr/$(get_libdir)/libodb-*.so \
	   "${ED}"/usr/$(get_libdir)/libodb-sqlite.so \
	   "${ED}"/usr/$(get_libdir)/libodb-sqlite-*.so \
	   "${ED}"/usr/$(get_libdir)/libpkgconf.so \
	   "${ED}"/usr/$(get_libdir)/libsqlite3.so \
	   "${ED}"/usr/$(get_libdir)/pkgconfig/libodb-sqlite.pc \
	   "${ED}"/usr/$(get_libdir)/pkgconfig/libodb.shared.pc \
	   "${ED}"/usr/$(get_libdir)/pkgconfig/libodb-sqlite.shared.pc \
	   "${ED}"/usr/$(get_libdir)/pkgconfig/libpkgconf.pc \
	   "${ED}"/usr/$(get_libdir)/pkgconfig/libodb.pc \
	   || die
	mkdir -p "${ED}"/usr/share/doc/${PF}/html || die
	mv -f "${ED}"/usr/share/doc/${PF}/*.xhtml "${ED}"/usr/share/doc/${PF}/html || die
}
