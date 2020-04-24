# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic libtool perl-functions toolchain-funcs multilib

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ImageMagick/ImageMagick.git"
	inherit git-r3
	MY_P="imagemagick-9999"
else
	MY_PV="$(ver_rs 3 '-')"
	MY_P="ImageMagick-${MY_PV}"
	SRC_URI="mirror://imagemagick/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="https://www.imagemagick.org/"

LICENSE="imagemagick"
SLOT="0/7.0.10"
IUSE="bzip2 corefonts +cxx djvu fftw fontconfig fpx graphviz hdri heif jbig jpeg jpeg2k lcms lqr lzma opencl openexr openmp pango perl png postscript q32 q8 raw static-libs svg test tiff truetype webp wmf X xml zlib"
RESTRICT="!test? ( test )"

REQUIRED_USE="corefonts? ( truetype )
	test? ( corefonts )"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	dev-libs/libltdl:0
	bzip2? ( app-arch/bzip2 )
	corefonts? ( media-fonts/corefonts )
	djvu? ( app-text/djvu )
	fftw? ( sci-libs/fftw:3.0 )
	fontconfig? ( media-libs/fontconfig )
	fpx? ( >=media-libs/libfpx-1.3.0-r1 )
	graphviz? ( media-gfx/graphviz )
	heif? ( media-libs/libheif:= )
	jbig? ( >=media-libs/jbigkit-2:= )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( >=media-libs/openjpeg-2.1.0:2 )
	lcms? ( media-libs/lcms:2= )
	lqr? ( media-libs/liblqr )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr:0= )
	pango? ( x11-libs/pango )
	perl? ( >=dev-lang/perl-5.8.8:0= )
	png? ( media-libs/libpng:0= )
	postscript? ( app-text/ghostscript-gpl )
	raw? ( media-libs/libraw:= )
	svg? (
		gnome-base/librsvg
		media-gfx/potrace
		)
	tiff? ( media-libs/tiff:0= )
	truetype? (
		media-fonts/urw-fonts
		>=media-libs/freetype-2
		)
	webp? ( media-libs/libwebp:0= )
	wmf? ( media-libs/libwmf )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libXext
		x11-libs/libXt
		)
	xml? ( dev-libs/libxml2:= )
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib:= )"

DEPEND="${RDEPEND}
	!media-gfx/graphicsmagick[imagemagick]
	X? ( x11-base/xorg-proto )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Apply hardening #664236
	cp "${FILESDIR}"/policy-hardening.snippet "${S}" || die
	sed -i -e '/^<policymap>$/ {
			r policy-hardening.snippet
			d
		}' \
		config/policy.xml || \
		die "Failed to apply hardening of policy.xml"
	einfo "policy.xml hardened"

	elibtoolize # for Darwin modules

	# For testsuite, see https://bugs.gentoo.org/show_bug.cgi?id=500580#c3
	local ati_cards mesa_cards nvidia_cards render_cards
	shopt -s nullglob
	ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
	if test -n "${ati_cards}"; then
		addpredict "${ati_cards}"
	fi
	mesa_cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
	if test -n "${mesa_cards}"; then
		addpredict "${mesa_cards}"
	fi
	nvidia_cards=$(echo -n /dev/nvidia* | sed 's/ /:/g')
	if test -n "${nvidia_cards}"; then
		addpredict "${nvidia_cards}"
	fi
	render_cards=$(echo -n /dev/dri/renderD128* | sed 's/ /:/g')
	if test -n "${render_cards}"; then
		addpredict "${render_cards}"
	fi
	shopt -u nullglob
	addpredict /dev/nvidiactl
}

src_configure() {
	local depth=16
	use q8 && depth=8
	use q32 && depth=32

	local openmp=disable
	use openmp && { tc-has-openmp && openmp=enable; }

	use perl && perl_check_env

	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lnsl -lsocket

	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable hdri)
		$(use_enable opencl)
		--with-threads
		--with-modules
		--with-quantum-depth=${depth}
		$(use_with cxx magick-plus-plus)
		$(use_with perl)
		--with-perl-options='INSTALLDIRS=vendor'
		--with-gs-font-dir="${EPREFIX}"/usr/share/fonts/urw-fonts
		$(use_with bzip2 bzlib)
		$(use_with X x)
		$(use_with zlib)
		--without-autotrace
		$(use_with postscript dps)
		$(use_with djvu)
		--with-dejavu-font-dir="${EPREFIX}"/usr/share/fonts/dejavu
		$(use_with fftw)
		$(use_with fpx)
		$(use_with fontconfig)
		$(use_with truetype freetype)
		$(use_with postscript gslib)
		$(use_with graphviz gvc)
		$(use_with heif heic)
		$(use_with jbig)
		$(use_with jpeg)
		$(use_with jpeg2k openjp2)
		--without-jxl
		$(use_with lcms)
		$(use_with lqr)
		$(use_with lzma)
		$(use_with openexr)
		$(use_with pango)
		$(use_with png)
		$(use_with raw)
		$(use_with svg rsvg)
		$(use_with tiff)
		$(use_with webp)
		$(use_with corefonts windows-font-dir "${EPREFIX}"/usr/share/fonts/corefonts)
		$(use_with wmf)
		$(use_with xml)
		--${openmp}-openmp
		--with-gcc-arch=no-automagic
	)
	CONFIG_SHELL=$(type -P bash) econf "${myeconfargs[@]}"
}

src_test() {
	# Install default (unrestricted) policy in $HOME for test suite #664238
	local _im_local_config_home="${HOME}/.config/ImageMagick"
	mkdir -p "${_im_local_config_home}" || \
		die "Failed to create IM config dir in '${_im_local_config_home}'"
	cp "${FILESDIR}"/policy.test.xml "${_im_local_config_home}/policy.xml" || \
		die "Failed to install default blank policy.xml in '${_im_local_config_home}'"

	local im_command= IM_COMMANDS=()
	if [[ ${PV} == "9999" ]] ; then
		IM_COMMANDS+=( "magick -version" ) # Show version we are using -- cannot verify because of live ebuild
	else
		IM_COMMANDS+=( "magick -version | grep -q -- \"${MY_PV}\"" ) # Verify that we are using version we just built
	fi
	IM_COMMANDS+=( "magick -list policy" ) # Verify that policy.xml is used
	IM_COMMANDS+=( "emake check" ) # Run tests

	for im_command in "${IM_COMMANDS[@]}"; do
		eval "${S}"/magick.sh \
			${im_command} || \
			die "Failed to run \"${im_command}\""
	done
}

src_install() {
	# Ensure documentation installation files and paths with each release!
	emake \
		DESTDIR="${D}" \
		DOCUMENTATION_PATH="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	rm -f "${ED}"/usr/share/doc/${PF}/html/{ChangeLog,LICENSE,NEWS.txt}
	dodoc {AUTHORS,README}.txt ChangeLog

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -exec rm -f {} +
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} +
	fi

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +
	# .la files in parent are not needed, keep plugin .la files
	rm "${ED}"/usr/$(get_libdir)/*.la || die

	if use opencl; then
		cat <<-EOF > "${T}"/99${PN}
		SANDBOX_PREDICT="/dev/nvidiactl:/dev/nvidia-uvm:/dev/ati/card:/dev/dri/card:/dev/dri/renderD128"
		EOF

		insinto /etc/sandbox.d
		doins "${T}"/99${PN} #472766
	fi

	insinto /usr/share/${PN}
	doins config/*icm
}

pkg_postinst() {
	local _show_policy_xml_notice=

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		_show_policy_xml_notice=yes
	else
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ! ver_test "${v}" -gt "7.0.8.10-r2"; then
				# This is an upgrade
				_show_policy_xml_notice=yes

				# Show this elog only once
				break
			fi
		done
	fi

	if [[ -n "${_show_policy_xml_notice}" ]]; then
		elog "For security reasons, a policy.xml file was installed in /etc/ImageMagick-7"
		elog "which will prevent the usage of the following coders by default:"
		elog ""
		elog "  - PS"
		elog "  - PS2"
		elog "  - PS3"
		elog "  - EPS"
		elog "  - PDF"
		elog "  - XPS"
	fi
}
