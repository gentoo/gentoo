# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DL_PV=2.36
DESCRIPTION="Converter for dat files for Rom Managers"
HOMEPAGE="http://www.logiqx.com/Tools/DatUtil/"
SRC_URI="http://www.logiqx.com/Tools/DatUtil/dutil${PV//.}.zip
	http://www.logiqx.com/Tools/DatLib/datlib${DL_PV//.}.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

BDEPEND="app-arch/unzip"

src_unpack() {
	unpack dutil${PV//.}.zip

	cd "${S}" || die
	mkdir -p dev/datlib || die
	cd dev/datlib || die

	unpack datlib${DL_PV//.}.zip
}

src_compile() {
	# Parallel make issue, see bug #244879 (so make the dirs first)
	emake -j1 \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		CFLAGS="${CFLAGS} -Idev" \
		LOGIQX=. \
		EXT= \
		UPX=@# \
		dlmaketree maketree || die "emake failed"

	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		CFLAGS="${CFLAGS} -Idev" \
		LOGIQX=. \
		EXT= \
		UPX=@# \
		|| die "emake failed"
}

src_install() {
	dobin datutil
	dodoc readme.txt whatsnew.txt
}
