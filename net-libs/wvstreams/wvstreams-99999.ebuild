# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
AT_NOELIBTOOLIZE=yes
inherit autotools flag-o-matic git-r3 multiprocessing toolchain-funcs out-of-source

DESCRIPTION="A network programming library in C++"
HOMEPAGE="https://github.com/apenwarr/wvstreams"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="GPL-2"
SLOT="0/5.0"
KEYWORDS=""
IUSE="+dbus debug doc libressl pam static-libs +zlib"

RDEPEND="
	sys-libs/readline:0=
	sys-libs/zlib
	dbus? ( >=sys-apps/dbus-1.4.20 )
	!libressl? ( <dev-libs/openssl-1.1:0= )
	libressl? ( dev-libs/libressl:0= )
	pam? ( sys-libs/pam )
"
DEPEND="
	${RDEPEND}
	dev-util/redo
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PATCHES=(
	"${FILESDIR}"/${PN}-99999-openssl-ldflags.patch
	"${FILESDIR}"/${PN}-99999-soname.patch
)

src_prepare() {
	sed -i -e 's|-pre||g' config.ac || die

	default

	ln -s config.ac configure.ac || die
	eautoreconf
}

my_src_configure() {
	append-flags -fno-strict-aliasing
	append-flags -fno-tree-dce -fno-optimize-sibling-calls #421375

	tc-export AR CC CXX

	econf \
		$(use_enable debug) \
		$(use_with dbus) \
		$(use_with pam) \
		$(use_with zlib) \
		--cache-file="${BUILD_DIR}"/config.cache \
		--disable-optimization \
		--localstatedir=/var \
		--without-qt \
		--without-valgrind
}

my_src_compile() {
	redo -j$(makeopts_jobs) || die

	if use doc; then
		doxygen "${S}"/Doxyfile || die
	fi
}

my_src_test() {
	redo -j$(makeopts_jobs) test || die
}

my_src_install() {
	DESTDIR="${D}" redo -j$(makeopts_jobs) install || die

	local lib
	for lib in $(find "${BUILD_DIR}" -name '*.so' -type l | grep -v libwvstatic); do
		insinto /usr/$(get_libdir)/pkgconfig
		doins "${BUILD_DIR}"/pkgconfig/$(basename ${lib/.so}).pc
	done

	if use doc; then
		#the list of files is too big for dohtml -r Docs/doxy-html/*
		docinto html
		dodoc -r Docs/doxy-html/*
	fi

	if ! use static-libs; then
		find "${D}/usr/$(get_libdir)" -name '*.a' -delete || die
	fi
}
