# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs eutils multilib autotools

DEB_P=${PN}_${PV}
DEB_PR=3.1

DESCRIPTION="Satellite tracking and orbital prediction"
HOMEPAGE="http://www.qsl.net/kd2bd/predict.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEB_P}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc gtk nls xforms xplanet"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses
	gtk? ( x11-libs/gtk+:2 )
	xforms? ( x11-libs/xforms )
	xplanet? ( x11-misc/xplanet[truetype] )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-earthtrack.patch
	epatch -p1 "${WORKDIR}"/${DEB_P}-${DEB_PR}.diff
	sed -i -e 's:predict\(.*\)/:predict-2.2.3\1/:g' \
		debian/patches/140*.diff || die
	sed -i -e 's:\(a\|b\)/:predict-2.2.3/:g' \
		debian/patches/180*.diff || die
	EPATCH_SOURCE=debian/patches epatch -p1 $(cat debian/patches/series)
	# fix some further array out of bounds errors
	sed -i -e "s/satname\[ 26/satname\[ 25/g" \
		clients/gsat-1.1.0/src/db.c || die
	sed -i -e "s/satname\[ 26/satname\[ 25/g" \
		clients/gsat-1.1.0/src/comms.c || die
	sed -i -e "s/output\[20\];/output[21];/" \
		utils/moontracker/moontracker.c || die
	# fix underlinking
	sed -i -e '/AC_OUTPUT/i \
AC_CHECK_LIB(m,cos) \
AC_CHECK_LIB(dl,dlclose)' \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		clients/gsat-1.1.0/configure.in || die
	sed -i \
		-e 's/gcc/$(CC) $(CFLAGS) $(LDFLAGS)/g' \
		-e 's/-o/-lm -o/g' \
		clients/gsat-1.1.0/plugins/Makefile || die

	# fix the hardcoded /usr/lib
	PRED_DIR=/usr/$(get_libdir)/${PN}
	sed -i -e "s:/usr/lib/${PN}:${EROOT}${PRED_DIR}:g" \
		predict.h vocalizer/vocalizer.c || die

	sed -i -e "s:/usr/lib:${EROOT}usr/$(get_libdir):g" \
		clients/gsat-1.1.0/src/globals.h || die

	if use gtk; then
		cd "${S}"/clients/gsat-* || die
		rm config.sub missing || die
		eautoreconf
	fi
}

src_configure() {
	if use gtk; then
		cd "${S}"/clients/gsat-* || die
		econf $(use_enable nls)
	fi
}

src_compile() {
	# predict uses a ncurses based configure script
	# this is what it does if it was bash based ;)

	local COMPILER="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
	einfo "Compiling predict"
	${COMPILER} predict.c -lm -lncurses -lpthread \
		-o predict || die "failed predict"
	einfo "Compiling predict-g1yyh"
	${COMPILER} predict-g1yyh.c -lm -lncurses -lpthread -lmenu \
		-o predict-g1yyh || die "failed predict-g1yyh"
	einfo "Compiling vocalizer"
	${COMPILER} vocalizer/vocalizer.c \
		-o vocalizer/vocalizer || die "failed vocalizer"
	local c
	for c in fodtrack geosat moontracker; do
		einfo "Compiling ${c}"
		cd "${S}"/utils/${c}* || die
		${COMPILER} ${c}.c -lm -o ${c} || die "failed ${c}"
	done
	einfo "Compiling kep_reload"
	cd "${S}"/clients/kep_reload
	${COMPILER} kep_reload.c \
		-o kep_reload || die "failed kep_reload"

	if use xplanet; then
		einfo "Compiling earthtrack"
		cd "${S}"/clients/earthtrack || die
		${COMPILER} earthtrack.c \
			-lm -o earthtrack || die "failed earthtrack"
	fi

	if use xforms; then
		einfo "Compiling map"
		cd "${S}"/clients/map || die
		${COMPILER} map.c map_cb.c map_main.c -lforms -lX11 -lm \
			-o map || die "Failed compiling map"
	fi

	if use gtk; then
		einfo "Compiling gsat"
		cd "${S}"/clients/gsat-* || die
		emake
		emake -C plugins
	fi
}

src_install() {
	dobin predict predict-g1yyh "${FILESDIR}"/predict-update
	dodoc CHANGES CREDITS HISTORY README NEWS debian/README.Debian
	doman docs/man/predict.1
	newman debian/predict-g1yyh.man predict-g1yyh.1
	insinto ${PRED_DIR}/default
	doins default/predict.*
	use doc && dodoc docs/pdf/predict.pdf

	cd "${S}"/vocalizer || die
	dobin vocalizer
	dosym  ../../../bin/vocalizer ${PRED_DIR}/vocalizer/vocalizer
	insinto ${PRED_DIR}/vocalizer
	doins *.wav

	cd "${S}"/clients/kep_reload || die
	dobin kep_reload
	newdoc README README.kep_reload
	doman "${S}"/debian/kep_reload.1

	cd "${S}"/utils/fodtrack-0.1 || die
	insinto /etc
	doins fodtrack.conf
	doman fodtrack.conf.5 fodtrack.8
	dobin fodtrack
	newdoc README README.fodtrack

	cd "${S}"/utils/geosat || die
	dobin geosat
	newdoc README README.geosa
	newman "${S}"/debian/geosat.man geosat.1

	cd "${S}"/utils/moontracker || die
	dobin moontracker
	newdoc README README.moontracker
	doman "${S}"/debian/moontracker.1

	if use xplanet; then
		cd "${S}"/clients/earthtrack || die
		ln -s earthtrack earthtrack2 || die
		dobin earthtrack earthtrack2
		newdoc README README.earthtrack
		doman "${S}"/debian/earthtrack.1
	fi

	if use xforms; then
		cd "${S}"/clients/map || die
		newbin map predict-map
		newdoc CHANGES CHANGES.map
		newdoc README README.map
		doman "${S}"/debian/predict-map.1
	fi

	if use gtk; then
		cd "${S}"/clients/gsat-* || die
		exeinto /usr/$(get_libdir)/gsat/plugins
		doexe plugins/radio_{FT736,FT847,ICR10,print,test} plugins/rotor_{print,pictrack}
		dobin src/gsat
		doman "${S}"/debian/gsat.1
		local i
		for i in AUTHORS ChangeLog NEWS README Plugin_API; do
			newdoc ${i} ${i}.gsat
		done
	fi
}

pkg_postinst() {
	einfo "To use the clients the following line will"
	einfo "have to be inserted into /etc/services"
	einfo "predict    1210/udp"
	einfo "The port can be changed to anything"
	einfo "the name predict is what is needed to work"
	einfo "after that is set run 'predict -s'"
	einfo ""
	einfo "To get list of satellites run 'predict-update'"
	einfo "before running predict this script will also update"
	einfo "the list of satellites so they are up to date."
}
