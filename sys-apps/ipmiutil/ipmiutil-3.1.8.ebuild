# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="http://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-1:0="
DEPEND="${RDEPEND}
	virtual/os-headers"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.7-flags.patch
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

	# Don't compress man pages
	sed '/gzip -nf/d' -i doc/Makefile.am || die

	eautoreconf
}

src_configure() {
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
