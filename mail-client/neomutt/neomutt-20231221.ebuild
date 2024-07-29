# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

if [[ ${PV} =~ 99999999$ ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/neomutt/neomutt.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
fi

TEST_FILES_COMMIT=8629adab700a75c54e8e28bf05ad092503a98f75
SRC_URI+=" test? ( https://github.com/${PN}/neomutt-test-files/archive/${TEST_FILES_COMMIT}.tar.gz -> neomutt-test-files-${TEST_FILES_COMMIT}.tar.gz )"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="https://neomutt.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="autocrypt berkdb doc gdbm gnutls gpgme idn kerberos kyotocabinet lmdb lz4
	nls notmuch pgp-classic qdbm sasl selinux smime-classic ssl tokyocabinet
	test zlib zstd"
REQUIRED_USE="
	autocrypt? ( gpgme )"

CDEPEND="
	app-misc/mime-types
	berkdb? (
		|| (
			sys-libs/db:5.3
			sys-libs/db:4.8
		)
	)
	gdbm? ( sys-libs/gdbm:= )
	kyotocabinet? ( dev-db/kyotocabinet )
	lmdb? ( dev-db/lmdb:= )
	nls? ( virtual/libintl )
	qdbm? ( dev-db/qdbm )
	tokyocabinet? ( dev-db/tokyocabinet )
	gnutls? ( >=net-libs/gnutls-1.0.17:= )
	gpgme? ( >=app-crypt/gpgme-1.13.1:= )
	autocrypt? ( >=dev-db/sqlite-3 )
	idn? ( net-dns/libidn2:= )
	kerberos? ( virtual/krb5 )
	notmuch? ( net-mail/notmuch:= )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( >=dev-libs/openssl-1.0.2u:0= )
	lz4? ( app-arch/lz4 )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )
"
DEPEND="${CDEPEND}
	dev-lang/tcl:=
	net-mail/mailbase
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		|| (
			www-client/lynx
			www-client/w3m
			www-client/elinks
		)
	)
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-mutt )
"

RESTRICT="!test? ( test )"

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	if [[ ${PV} =~ 99999999$ ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {
	local myconf=(
		"$(usex doc --full-doc --disable-doc)"
		"$(use_enable nls)"
		"$(use_enable notmuch)"

		"$(use_enable autocrypt)"
		"$(use_enable gpgme)"
		"$(use_enable pgp-classic pgp)"
		"$(use_enable smime-classic smime)"

		# Database backends.
		"$(use_enable berkdb bdb)"
		"$(use_enable gdbm)"
		"$(use_enable kyotocabinet)"
		"$(use_enable qdbm)"
		"$(use_enable tokyocabinet)"

		# Header compression.
		"$(use_enable lz4)"
		"$(use_enable zlib)"
		"$(use_enable zstd)"

		--disable-idn
		"$(use_enable idn idn2)"
		"$(use_enable kerberos gss)"
		"$(use_enable lmdb)"
		"$(use_enable sasl)"
		"--sysconfdir=${EPREFIX}/etc/${PN}"
		"$(use_enable ssl)"
		"$(use_enable gnutls)"

		"$(usex test --testing --disable-testing)"
	)

	if is-flagq -fsanitize=address; then
		myconf+=( --asan )
	fi
	if is-flagq -fsanitize=undefined; then
		myconf+=( --ubsan )
	fi

	econf CCACHE=none CC_FOR_BUILD="$(tc-getCC)" "${myconf[@]}"
}

src_test() {
	local test_dir="$(readlink --canonicalize "${S}"/../neomutt-test-files-${TEST_FILES_COMMIT})"
	pushd ${test_dir} || die "Could not cd into test_dir"
	NEOMUTT_TEST_DIR="${test_dir}" ./setup.sh \
		|| die "Failed to run the setup.sh script"
	popd || die "Could not cd back"
	NEOMUTT_TEST_DIR="${test_dir}" emake test
}

src_install() {
	emake DESTDIR="${D}" install

	# A man-page is always handy, so fake one - here neomuttrc.5 (neomutt.1
	# already exists)
	if use !doc; then
		sed -n \
			-e '/^\(CC_FOR_BUILD\|CFLAGS_FOR_BUILD\)\s*=/p' \
			-e '/^\(EXTRA_CFLAGS_FOR_BUILD\|LDFLAGS_FOR_BUILD\)\s*=/p' \
			-e '/^\(EXEEXT\|SRCDIR\)\s*=/p' \
			Makefile > docs/Makefile.fakedoc || die
		sed -n \
			-e '/^MAKEDOC_CPP\s*=/,/^\s*$/p' \
			-e '/^docs\/\(makedoc$(EXEEXT)\|neomutt\.1\|neomuttrc\.5\)\s*:/,/^\s*$/p' \
			docs/Makefile.autosetup >> docs/Makefile.fakedoc || die
		emake -f docs/Makefile.fakedoc docs/neomutt.1
		emake -f docs/Makefile.fakedoc docs/neomuttrc.5
		doman docs/neomutt.1 docs/neomuttrc.5
	fi

	dodoc LICENSE* ChangeLog* README*
}

pkg_postinst() {
	if use gpgme && ( use pgp-classic || use smime-classic ); then
		ewarn "  Note that gpgme (old gpg) includes both pgp and smime"
		ewarn "  support.  You can probably remove pgp-classic (old crypt)"
		ewarn "  and smime-classic (old smime) from your USE-flags and"
		ewarn "  only enable gpgme."
	fi

	if use autocrypt && ! use idn; then
		ewarn "  It is highly recommended that NeoMutt be also configured"
		ewarn "  with idn when autocrypt is enabled."
	fi
}
