# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

DESCRIPTION="Archlinux's binary package manager"
HOMEPAGE="https://archlinux.org/pacman/"

# workaround until tests are fixed/sorted out
RESTRICT="test"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.archlinux.org/pacman.git"
else
	SRC_URI="https://sources.archlinux.org/other/pacman/${P}.tar.gz"
	# Do *not* re-add ~x86!
	# https://www.archlinux.org/news/phasing-out-i686-support/
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="curl debug doc +gpg test"
COMMON_DEPEND="app-arch/libarchive:=[lzma]
	gpg? ( >=app-crypt/gpgme-1.4.0:= )
	dev-libs/openssl:0=
	curl? ( net-misc/curl )
	virtual/libiconv
	virtual/libintl"
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	doc? ( app-doc/doxygen )
	test? ( sys-apps/fakeroot
	sys-apps/fakechroot )"

PATCHES=( "${FILESDIR}"/${P}-cve-2016-5434.patch )

src_prepare() {
	# Remove a line that adds "-Werror" in ./configure when
	# "--enable-debug" is passed:
	sed -i -e '/-Werror/d' configure.ac || die

	default
}

src_configure() {
	local myeconfargs=(
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
	emake
	emake -C contrib
	default
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

	default
	# avoid creating stuff inside /var/cache/
	# see bug #633742 for more information
	rm -r "${D}"/var/cache/pacman
}

pkg_postinst() {
	einfo ""
	einfo "The default root dir was set to ${EPREFIX}/var/chroot/archlinux"
	einfo "to avoid breaking Gentoo systems due to oscitancy."
	einfo "If you prefer another directory, take a look at"
	einfo "pacman’s parameter -r|--root)."
	einfo ""
	einfo "You will need to setup at least one mirror in /etc/pacman.d/mirrorlist."
	einfo "Please generate it manually according to the Archlinux documentation:"
	einfo "https://wiki.archlinux.org/index.php/Mirror"
	einfo ""
	ewarn "Archlinux is dropping support for x86 (i686 called there) entirely"
	ewarn "in Nov 2017. Please keep this in mind when setting up new systems."
	ewarn "For more details see"
	ewarn "https://www.archlinux.org/news/phasing-out-i686-support"
	einfo ""
}
