# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="https://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-1:="
DEPEND="
	${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.9-lib_symlink.patch
	"${FILESDIR}"/${PN}-3.1.8-fix-configure.patch
)

src_prepare() {
	default

	# Fix hardcoded CFLAGS
	sed -i \
		-e 's|-O2 -g|$(CFLAGS)|g' \
		-e 's|-g -O2|$(CFLAGS)|g' \
		util/Makefile.am* || die

	# The configure script makes some guarded and some blind calls to rpm &
	# rpmbuild, that trigger sandbox warnings if rpm is installed in Gentoo.
	sed -r -i -e 's/which rpm/false &/' configure.ac || die
	sed -r -i -e 's/`(rpm|rpmbuild)/`false \1/' configure.ac || die
	# Don't try to inject -O2 or hardening flags (which we set in the toolchain).
	sed -i -e '/CFLAGS="-O2"/d' -e '/cfhard=/d' configure.ac || die

	# Don't compress man pages
	sed '/gzip -nf/d' -i doc/Makefile.am || die

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/863590
	# https://github.com/arcress0/ipmiutil/issues/21
	filter-lto

	local myeconfargs=(
		--disable-systemd
		--enable-sha256
		--enable-lanplus
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Ugly workaround. Upstream is misusing the make system here
	# and it doesn't even work.
	# Please check on each bump if this workaround is still required.
	# Yup, still needed in 3.18
	pushd lib/lanplus &>/dev/null || die
	emake
	cp libipmi_lanplus.a .. || die
	popd &>/dev/null || die

	emake
}

src_install() {
	emake DESTDIR="${D}" sysdto="${D}/$(systemd_get_systemunitdir)" install
	dodoc -r AUTHORS ChangeLog NEWS README TODO doc/UserGuide

	# Init scripts are only for Fedora
	# TODO: ship OpenRC systems for non-systemd?
	rm -r "${ED}"/etc/init.d || die 'remove initscripts failed'

	# --disable-static has no effect
	if ! use static-libs ; then
		find "${ED}" -type f -name '*.a' -delete || die
	fi

	keepdir /var/lib/ipmiutil
}
