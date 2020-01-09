# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit autotools

DESCRIPTION="Archlinux's binary package manager"
HOMEPAGE="https://archlinux.org/pacman/"

PATCHES=()

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.archlinux.org/pacman.git"
else
	SRC_URI="https://sources.archlinux.org/other/pacman/${P}.tar.gz"
	# Do *not* re-add ~x86!
	# https://www.archlinux.org/news/phasing-out-i686-support/
	KEYWORDS="-* ~amd64"

	PATCHES+=( "${FILESDIR}"/${PN}-5.0.2-CVE-2016-5434.patch )
fi

LICENSE="GPL-2"
SLOT="0/10"

IUSE="curl debug doc +gpg libressl test"
COMMON_DEPEND="
	app-arch/libarchive:=[lzma]
	gpg? ( >=app-crypt/gpgme-1.4.0:= )
	curl? ( net-misc/curl )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	virtual/libiconv
	virtual/libintl
"
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	doc? ( app-doc/doxygen )
	test? (
		sys-apps/fakeroot
		sys-apps/fakechroot
	)
"

# workaround until tests are fixed/sorted out
RESTRICT="test"

src_prepare() {
	# Remove a line that adds "-Werror" in ./configure when
	# "--enable-debug" is passed:
	sed -i -e '/-Werror/d' configure.ac || die

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--localstatedir=/var
		--disable-git-version
		--with-openssl
		# Help protect user from shooting his/her Gentoo installation
		# in its foot.
		--with-root-dir="${EPREFIX}/var/chroot/archlinux"
		$(use_enable debug)
		# full doc with doxygen
		$(use_enable doc doxygen)
		$(use_with curl libcurl)
		$(use_with gpg gpgme)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	emake -C contrib
}

src_install() {
	dodir /etc/pacman.d/
	# contributed parts, i.e. not pacman itself, but useful helpers and some templates and basic docs
	dobin "${S}"/contrib/{bacman,checkupdates,pac{cache,diff,list,log-pkglist,scripts,search},rankmirrors,updpkgsums}
	newdoc "${S}"/contrib/README contrib-README
	dodoc "${S}"/contrib/PKGBUILD.vim
	# create /var/chroot/archlinux
	# see bug #631754
	dodir /var/chroot/archlinux
	keepdir /var/chroot/archlinux /var/lib/pacman

	default
	find "${D}" -name '*.la' -delete || die

	# avoid creating stuff inside /var/cache/
	# see bug #633742 for more information
	rm -r "${D}"/var/cache/pacman
	rmdir "${D}"/var/cache
}

pkg_postinst() {
	einfo ""
	einfo "The default root dir was set to ${EPREFIX}/var/chroot/archlinux"
	einfo "to avoid breaking Gentoo systems due to oscitancy."
	einfo "If you prefer another directory, take a look at"
	einfo "pacman's parameter -r|--root)."
	einfo ""
	einfo "You will need to setup at least one mirror in /etc/pacman.d/mirrorlist."
	einfo "Please generate it manually according to the Archlinux documentation:"
	einfo "https://wiki.archlinux.org/index.php/Mirror"
	einfo ""
}
