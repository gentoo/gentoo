# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25"

inherit eutils ruby-ng

PLUGIN_HASH="30071c3008e4616e723cf4e734fc79254019af09"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://toshia.dip.jp/mikutter.git
		https://github.com/toshia/twitter_api_keys.git"
	inherit git-r3
	SRC_URI="https://raw.githubusercontent.com/toshia/twitter_api_keys/${PLUGIN_HASH}/twitter_api_keys.rb"
	KEYWORDS=""
	EGIT_CHECKOUT_DIR="${WORKDIR}/all"
else
	MY_P="${PN}.${PV}"
	SRC_URI="http://mikutter.hachune.net/bin/${MY_P}.tar.gz
		https://raw.githubusercontent.com/toshia/twitter_api_keys/${PLUGIN_HASH}/twitter_api_keys.rb"
	KEYWORDS="~amd64"
	RUBY_S="${PN}"
fi

DESCRIPTION="Simple, powerful and moeful twitter client"
HOMEPAGE="http://mikutter.hachune.net/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+libnotify"

DEPEND=""
RDEPEND="
	libnotify? ( x11-libs/libnotify )
	media-sound/alsa-utils"

ruby_add_rdepend "<dev-ruby/addressable-2.6
	dev-ruby/delayer
	>=dev-ruby/delayer-deferred-2.0
	>=dev-ruby/diva-0.3.2
	dev-ruby/httpclient
	dev-ruby/json:0
	dev-ruby/instance_storage
	dev-ruby/memoist
	dev-ruby/moneta
	dev-ruby/nokogiri
	>=dev-ruby/oauth-0.5.1
	>=dev-ruby/pluggaloid-1.1.1
	dev-ruby/rcairo
	>=dev-ruby/ruby-gettext-3.2.9
	>=dev-ruby/ruby-gtk2-3.3.0
	>dev-ruby/ruby-hmac-0.4
	dev-ruby/totoridipjp
	dev-ruby/twitter-text:=
	>dev-ruby/typed-array-0.1
	virtual/ruby-ssl"

all_ruby_unpack() {
	if [ "${PV}" = "9999" ];then
		git-3_src_unpack
	else
		default
	fi
}

all_ruby_install() {
	local rubyversion

	if use ruby_targets_ruby25; then
		rubyversion=ruby25
	elif use ruby_targets_ruby24; then
		rubyversion=ruby24
	fi

	exeinto /usr/share/mikutter
	doexe mikutter.rb
	insinto /usr/share/mikutter
	doins -r core plugin
	sed -e "s/ruby19/${rubyversion}/" "${FILESDIR}"/mikutter \
		| newbin - mikutter
	dodoc README
	make_desktop_entry mikutter Mikutter \
		/usr/share/mikutter/core/skin/data/icon.png

	insinto /usr/share/mikutter/plugin/twitter_api_keys
	newins "${DISTDIR}"/twitter_api_keys.rb twitter_api_keys.rb.in
}

pkg_postinst() {
	echo
	elog "To use Twitter, you need to setup your Consumer Key/Consumer Secret by running"
	elog "  emerge --config =${PF}"
}

pkg_config() {
	local PLUGIN_DIR="${EROOT}"/usr/share/mikutter/plugin
	local CK CS

	echo
	einfon "Please input your Consumer Key for Twitter: "
	read -r CK

	echo
	einfon "Please input your Consumer Secret for Twitter: "
	read -r CS

	if [ -z "${CK}" -o -z "${CS}" ]; then
		eerror "Consumer Key or Consumer Secret is missing."
		return
	fi

	sed -e "/consumer_key = /s!''!'${CK}'!" \
		-e "/consumer_secret = /s!''!'${CS}'!" \
		${PLUGIN_DIR}/twitter_api_keys/twitter_api_keys.rb.in > \
			${PLUGIN_DIR}/twitter_api_keys/twitter_api_keys.rb

	echo
	einfo "Consuker Key/Consumer secret is set."
}
