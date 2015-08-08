# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20"

inherit eutils ruby-ng

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://toshia.dip.jp/mikutter.git"
	inherit git-2
	KEYWORDS=""
	EGIT_SOURCEDIR="${WORKDIR}/all"
else
	MY_P="${PN}.${PV}"
	SRC_URI="http://mikutter.hachune.net/bin/${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	RUBY_S="${PN}"
fi

DESCRIPTION="Simple, powerful and moeful twitter client"
HOMEPAGE="http://mikutter.hachune.net/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+libnotify sound"

DEPEND=""
RDEPEND="
	libnotify? ( x11-libs/libnotify )
	sound? ( media-sound/alsa-utils )"

ruby_add_rdepend "dev-ruby/addressable
	dev-ruby/bsearch
	dev-ruby/delayer
	dev-ruby/json
	dev-ruby/memoize
	>=dev-ruby/moneta-0.7
	>=dev-ruby/oauth-0.4.7
	dev-ruby/rcairo
	>=dev-ruby/ruby-gettext-3.0.1
	>=dev-ruby/ruby-gtk2-2.2.0
	dev-ruby/ruby-hmac
	dev-ruby/typed-array
	virtual/ruby-ssl"

all_ruby_unpack() {
	if [ "${PV}" = "9999" ];then
		git-2_src_unpack
	else
		default
	fi
}

each_ruby_install() {
	exeinto /usr/share/mikutter
	doexe mikutter.rb
	insinto /usr/share/mikutter
	doins -r core plugin
	#if use ruby_targets_ruby21; then
	#	sed -e 's/ruby19/ruby21/' "${FILESDIR}"/mikutter
	if use ruby_targets_ruby20; then
		sed -e 's/ruby19/ruby20/' "${FILESDIR}"/mikutter
	else
		die
	fi | newbin - mikutter
	dodoc README
	make_desktop_entry mikutter Mikutter \
		/usr/share/mikutter/core/skin/data/icon.png
}
