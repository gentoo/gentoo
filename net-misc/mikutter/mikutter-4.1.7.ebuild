# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

inherit desktop ruby-ng

PLUGIN_HASH="30071c3008e4616e723cf4e734fc79254019af09"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://mikutter.hachune.net/mikutter.git
		https://github.com/toshia/twitter_api_keys.git"
	inherit git-r3
	SRC_URI="https://raw.githubusercontent.com/toshia/twitter_api_keys/${PLUGIN_HASH}/twitter_api_keys.rb"
	EGIT_CHECKOUT_DIR="${WORKDIR}/all"
else
	SRC_URI="http://mikutter.hachune.net/bin/${P}.tar.gz
		https://raw.githubusercontent.com/toshia/twitter_api_keys/${PLUGIN_HASH}/twitter_api_keys.rb"
	KEYWORDS="~amd64 ~riscv"
fi

DESCRIPTION="Simple, powerful and moeful twitter client"
HOMEPAGE="https://mikutter.hachune.net/"

LICENSE="MIT"
SLOT="0"
IUSE="+libnotify"

DEPEND=""
RDEPEND="
	libnotify? ( x11-libs/libnotify )
	media-sound/alsa-utils"

ruby_add_rdepend "=dev-ruby/addressable-2.8*
	>=dev-ruby/delayer-1.1.2
	!>=dev-ruby/delayer-2.0
	>=dev-ruby/delayer-deferred-2.2.0
	!>=dev-ruby/delayer-deferred-3.0
	>=dev-ruby/diva-1.0.2
	!>=dev-ruby/diva-2.0
	dev-ruby/httpclient
	dev-ruby/json:2
	>=dev-ruby/memoist-0.16.2
	!>=dev-ruby/memoist-0.17
	dev-ruby/moneta
	dev-ruby/nokogiri
	>=dev-ruby/oauth-0.5.4
	>=dev-ruby/pluggaloid-1.5.0
	!>=dev-ruby/pluggaloid-2.0
	dev-ruby/rcairo
	>=dev-ruby/ruby-gettext-3.3.5
	!>=dev-ruby/ruby-gettext-3.4
	=dev-ruby/ruby-gtk2-3.4*
	>=dev-ruby/typed-array-0.1.2
	!>=dev-ruby/typed-array-0.2
	dev-ruby/twitter-text
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
	local r

	for r in $USE_RUBY; do
		if use ruby_targets_${r}; then
			rubyversion=${r}
		fi
	done

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
