# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

tagId="6.0-r0"
DESCRIPTION="Simple Realtime media Server"
HOMEPAGE="https://ossrs.io/"
SRC_URI="https://github.com/ossrs/${PN}/archive/refs/tags/v${tagId}.tar.gz
	-> ${PN}-${tagId}.tar.gz"

S="${WORKDIR}"/${PN}-${tagId}

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="h265 signal-api srt threads"

DEPEND="
	dev-libs/openssl:0=
	media-video/ffmpeg:=
	srt? ( net-libs/srt:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.85-cmake.patch
	"${FILESDIR}"/${PN}-6.0.101-configure.patch
	"${FILESDIR}"/${PN}-6.0.48-execStack.patch
	"${FILESDIR}"/${PN}-6.0.48-fixAliasing.patch
	"${FILESDIR}"/${PN}-6.0.181-edgeFix.patch
	"${FILESDIR}"/${P}-noWhich.patch
	"${FILESDIR}"/${P}-parallel.patch
	"${FILESDIR}"/${P}-noGCC.patch
	"${FILESDIR}"/${P}-gcc17.patch
)

src_prepare() {
	cd trunk
	default
}

src_configure() {
	cd trunk
	local myconf=(
		--config=/etc/srs/
		--generic-linux=on
		--https=off
		--rtc=off
		--sanitizer=off
		--sys-ffmpeg=on
		--sys-srt=on
		--sys-srtp=on
		--sys-ssl=on
		--cxx="$(tc-getCXX)"
		--h265=$(usex h265 on off)
		--signal-api=$(usex signal-api on off)
		--single-thread=$(usex threads off on)
		--srt=$(usex srt on off)
	)

	./configure "${myconf[@]}" || die
}

src_compile() {
	cd trunk
	# Build libst.a
	emake -C 3rdparty/st-srs \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		EXTRA_CFLAGS="${CFLAGS} -DMALLOC_STACK" \
		linux-debug
	cp 3rdparty/st-srs/obj/{st.h,libst.a} objs/st

	default
}

src_install() {
	einstalldocs

	cd trunk
	# Install executable
	newbin objs/srs srs-media

	# Install configuration file
	insinto /usr/share/srs/conf
	doins conf/*.conf

	# Install the Web files
	insinto /usr/share/srs/html
	doins -r objs/nginx/html/*

	newinitd "${FILESDIR}"/init.d srs
	newconfd "${FILESDIR}"/conf.d srs

	insinto /etc/srs
	doins "${FILESDIR}"/srs.conf
}
