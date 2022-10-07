# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs

MY_PV=${PV/_p/-}  # e.g.: 4.4c_p4 -> 4.4c-4
MY_P=${PN}-${MY_PV}

DESCRIPTION="Practical Scheme Compiler with many extensions"
HOMEPAGE="http://www-sop.inria.fr/indes/fp/Bigloo/index.html"
SRC_URI="ftp://ftp-sop.inria.fr/indes/fp/Bigloo/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa avahi emacs flac +gmp gpg gstreamer java libuv mp3 pulseaudio +sqlite"
REQUIRED_USE="flac? ( alsa ) mp3? ( alsa )"

EMACS_DEPEND="emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="
	dev-libs/boehm-gc[threads]
	dev-libs/libpcre2:=
	dev-libs/libunistring:=
	dev-libs/openssl:=
	alsa? ( media-libs/alsa-lib )
	avahi? ( net-dns/avahi )
	flac? ( media-libs/flac:= )
	gmp? ( dev-libs/gmp:= )
	gpg? ( app-crypt/gnupg )
	gstreamer? (
		media-libs/gst-plugins-base:1.0=
		media-libs/gstreamer:1.0=
	)
	java? ( virtual/jdk:* )
	libuv? ( dev-libs/libuv:= )
	mp3? ( media-sound/mpg123 )
	pulseaudio? ( media-sound/pulseaudio )
	sqlite? ( dev-db/sqlite:3= )
"
RDEPEND="
	${DEPEND}
	${EMACS_DEPEND}
	sys-devel/binutils
	sys-devel/gdb
"
BDEPEND="
	${EMACS_DEPEND}
	sys-apps/texinfo
"

DOCS=( ChangeLog README.md TODO.org )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	sed -e "/^ar=/s|=|=\"$(tc-getAR)\"|" \
		-e "/^ranlib=/s|=|=\"$(tc-getRANLIB)\"|" \
		-i ./configure || die

	sed "s|^ar |$(tc-getAR) |" -i ./autoconf/ranlib || die
}

src_configure() {
	tc-export AR AS CC CPP CXX LD
	export CFLAGS
	export LDFLAGS

	local myconf=(
		# Compilation
		--as="$(tc-getAS)"
		--cc="$(tc-getCC)"
		--cflags="${CFLAGS}"
		--cpicflags="-fPIC"
		--cwarningflags=""
		--ldflags="${LDFLAGS}"
		# Installation directories
		--prefix=/usr
		--bindir=/usr/share/${PN}/bin
		--docdir=/usr/share/doc/${PF}
		--infodir=/usr/share/info
		--libdir=/usr/"$(get_libdir)"
		--mandir=/usr/share/man
		# Custom internal components
		--customgc=no
		--customgmp=no
		--customlibuv=no
		--customunistring=no
		--jvm=$(usex java)
		--native=yes
		--sharedbde=yes
		--sharedcompiler=yes
		--strip=no
		# Libraries, Bigloo calls them APIs
		--disable-phidget  # not important for now, only in ::ros-overlay ?
		--enable-calendar  # iCalendar parser
		--enable-crypto
		--enable-csv   # parsing CSV files
		--enable-mail  # IMAP protocol implementation
		--enable-multimedia
		--enable-packrat  # packrat parser
		--enable-phone
		--enable-pkgcomp
		--enable-pthread
		--enable-srfi1
		--enable-srfi18
		--enable-ssl
		--enable-text  # BibTeX parser
		--enable-upnp  # Upnp protocol implementation
		--enable-web   # XML, CGI, and RSS parsers
		$(use_enable alsa)
		$(use_enable avahi)
		$(use_enable flac wav)
		$(use_enable flac)
		$(use_enable gmp srfi27)
		$(use_enable gmp)
		$(use_enable gpg openpgp)
		$(use_enable gstreamer)
		$(use_enable libuv)
		$(use_enable mp3 mpg123)
		$(use_enable pulseaudio)
		$(use_enable sqlite pkglib)
		$(use_enable sqlite)
		# GNU Emacs libraries
		--bee=$(usex emacs full partial)
		--emacs=$(usex emacs "${EMACS}" "no")
		--lispdir=$(usex emacs "${SITELISP}/${PN}" "")
	)
	ebegin "Configuring Bigloo with the following options: ${myconf[@]}"
	sh ./configure "${myconf[@]}"
	eend $? || die "configure script failed"

	# When Emacs version is too high (e.g. 28) bigloo will skip compiling
	# and installing the Emacs support files.
	# The file "bmacs/Makefile" lists all officially supported Emacs versions.
	if use emacs ; then
		sed "/^EMACSBRAND=/s|generic|emacs23|" -i Makefile.config || die
	fi
}

src_compile() {
	default

	emake -C bdl
	emake -C bdb
	emake -C cigloo

	use emacs && emake -C bmacs
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" LN_S="ln -rs" install
	emake DESTDIR="${D}" -C bdl install
	emake DESTDIR="${D}" -C bdb install
	emake DESTDIR="${D}" -C cigloo install

	# The ".sh" scripts set proper environment and library order for Bigloo,
	# but programs (and the Bigloo Emacs library, "bee-mode") want "bigloo",
	# not "bigloo.sh". To make programs work we install all executable files
	# into "/usr/share/bigloo/bin", and then pick one by one for non-scripts:
	# if a script with ".sh" extensions exists, then we link the script,
	# not the picked executable to a binary name, otherwise link the binary.
	mkdir -p "${D}"/usr/bin || die
	pushd "${D}" >/dev/null || die
	local bin bin_link
	for bin in usr/share/${PN}/bin/* ; do
		if [[ ${bin} != *.sh ]] ; then
			bin_link=usr/bin/$(basename ${bin})
			if [[ -f ${bin}.sh ]] ; then
				ln -s ../../${bin}.sh ${bin_link} || die
			else
				ln -s ../../${bin} ${bin_link} || die
			fi
		fi
	done
	popd >/dev/null || die

	if use emacs ; then
		emake DESTDIR="${D}" install-bee
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
