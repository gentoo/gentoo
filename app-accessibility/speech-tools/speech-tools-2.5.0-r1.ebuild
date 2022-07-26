# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_P=${P/speech-/speech_}
PATCHSET="r3"

DESCRIPTION="Speech tools for Festival Text to Speech engine"
HOMEPAGE="http://www.cstr.ed.ac.uk/projects/speech_tools/"
SRC_URI="http://www.festvox.org/packed/festival/$(ver_cut 1-2)/${MY_P}-release.tar.gz
	https://dev.gentoo.org/~neurogeek/${PN}/speech_tools-2.1-${PATCHSET}-patches.tar.gz"
S="${WORKDIR}/speech_tools"

LICENSE="FESTIVAL HPND BSD rc regexp-UofT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="nas openmp X"

RDEPEND="
	media-libs/alsa-lib
	sys-libs/ncurses:=
	nas? ( media-libs/nas )
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md lib/cstrutt.dtd lib/example_data )

PATCHES=(
	"${WORKDIR}/patch/02_all_gcc42.patch"
	"${WORKDIR}/patch/03_all_GentooLinux.patch"
	"${WORKDIR}/patch/05_all_sharedlib.patch"
	"${WORKDIR}/patch/06_all_gcc43-include.patch"
	"${WORKDIR}/patch/09_all_remove-shared-refs.patch"
	"${WORKDIR}/patch/10_all_base_class.patch"
	"${WORKDIR}/patch/81_all_etcpath.patch"
	"${WORKDIR}/patch/91_all_gentoo-config.patch"
	"${WORKDIR}/patch/92_all_ldflags_fix.patch"
	"${WORKDIR}/patch/94_all_ncurses_tinfo.patch"

	# Fix underlinking, bug #493204
	"${FILESDIR}/${PN}-2.1-underlinking.patch"
	"${FILESDIR}/${PN}-2.5.0-fno-common.patch"
	"${FILESDIR}/${PN}-2.5.0-drop-curses.patch"
	"${FILESDIR}/${P}-warnings.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	sed -i -e '/^CXXFLAGS  =/s|CC_OTHER_FLAGS|CXX_OTHER_FLAGS|' \
		config/compilers/gcc_defaults.mak || die

	sed -i -e 's,{{HORRIBLELIBARCHKLUDGE}},"/usr/$(get_libdir)",' \
		main/siod_main.cc || die

	# bug #309983
	sed -i -e "s:\(GCC_SYSTEM_OPTIONS =\).*:\1:" \
		"${S}"/config/systems/sparc_SunOS5.mak || die

	sed -i -e "s|\$(OMP_OPTS)|$(use openmp && echo -fopenmp)|g" \
		-e "s|\$(OMP_DEFS)|$(use openmp && echo -DOMP_WAGON=1)|g" \
		-e "/MAKE_SHARED_LIB =/s|-shared|$(use openmp && echo -fopenmp) -shared|" \
		config/compilers/gcc_defaults.mak || die

	eautoreconf
}

src_configure() {
	local CONFIG=config/config.in

	sed -i -e 's/@COMPILERTYPE@/gcc42/' ${CONFIG} || die

	if use nas; then
		sed -i -e "s/#.*\(INCLUDE_MODULES += NAS_AUDIO\)/\1/" \
			${CONFIG} || die
	fi

	if ! use X; then
		sed -i -e "s/-lX11 -lXt//" config/modules/esd_audio.mak || die
	fi

	econf
}

src_compile() {
	emake -j1 \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CC_OTHER_FLAGS="${CFLAGS}" \
		CXX_OTHER_FLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	default

	dolib.so lib/libest*.so*

	insinto /usr/share/speech-tools
	doins -r config base_class

	insinto /usr/share/speech-tools/lib
	doins -r lib/siod

	mv include speech-tools || die
	doheader -r speech-tools
	dosym ../../include/speech-tools /usr/share/speech-tools/include

	for file in bin/*; do
		[ "${file}" = "bin/Makefile" ] && continue
		dobin ${file}
		dstfile="${ED}/usr/${file}"
		sed -i -e "s:${S}/testsuite/data:/usr/share/speech-tools/testsuite:g" \
			${dstfile} || die
		sed -i -e "s:${S}/bin:/usr/$(get_libdir)/speech-tools:g" \
			${dstfile} || die
		sed -i -e "s:${S}/main:/usr/$(get_libdir)/speech-tools:g" \
			${dstfile} || die

		# This just changes LD_LIBRARY_PATH
		sed -i -e "s:${S}/lib:/usr/$(get_libdir):g" ${dstfile} || die
	done

	exeinto /usr/$(get_libdir)/speech-tools
	for file in `find main -perm /111 -type f`; do
		doexe ${file}
	done

	# Remove bcat (only useful for testing on windows, see bug #418301).
	rm "${ED}/usr/bin/bcat" || die
	rm "${ED}/usr/$(get_libdir)/speech-tools/bcat" || die
}
