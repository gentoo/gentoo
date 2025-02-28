# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="PKCS#11 provider cryptographic hardware"
HOMEPAGE="https://sourceforge.net/projects/opencryptoki"
SRC_URI="https://github.com/opencryptoki/opencryptoki/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0 BSD CPL-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~s390 ~x86"
IUSE="debug +tpm"

DEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	net-nds/openldap
	tpm? ( app-crypt/trousers )
	>=dev-libs/openssl-1.1.1:0=
"
RDEPEND="
	${DEPEND}
	acct-group/pkcs11
"
DOCS=( COPYRIGHTS ChangeLog FAQ	README.md )

# tests right now basically don't exist; the only available thing would
# test against an installed copy and would kill a running pcscd, all
# things that we're not interested to.
RESTRICT=test

src_prepare() {
	default
	# provide missing AX_PROG_CC_FOR_BUILD macro
	ln -s "${FILESDIR}/m4_ax_prog_cc_for_build.m4" "${S}/m4/" || die
	# use our autoreconf instread of bootstrap.sh
	eautoreconf
}

src_configure() {
	# Since upstream by default seem to enable any possible token, even
	# when they don't seem to be used, we limit ourselves to the
	# software emulation token (swtok) and if the user enabled the tpm
	# USE flag, tpmtok.  The rest of the tokens seem to be hardware- or
	# software-dependent even when they build fine without their
	# requirements, but until somebody asks for those, I'd rather not
	# enable them.

	# REVIEW: seems like there's automagic present here
	local myeconfargs=(
		# package uses ${localstatedir}/lib as the default path, so if we
		# leave it to econf, it'll create /var/lib/lib.
		--localstatedir=/var

		--enable-daemon
		--enable-fast-install
		--enable-library
		--enable-swtok
		--disable-testcases # see RESTRICT
		--disable-ccatok
		--disable-ep11tok
		--disable-icatok
		$(use_enable tpm tpmtok)
	)

	# We don't use --enable-debug because that tinkers with the CFLAGS
	# and we don't want that. Instead we append -DDEBUG which enables
	# debug information.
	myeconfargs+=( --disable-debug )
	use debug && append-flags -DDEBUG

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# Install libopencryptoki in the standard directory for libraries.
	mv "${ED}"/usr/$(get_libdir)/opencryptoki/libopencryptoki.so* "${ED}"/usr/$(get_libdir) || die
	rm "${ED}"/usr/$(get_libdir)/pkcs11/libopencryptoki.so || die
	dosym ../libopencryptoki.so /usr/$(get_libdir)/pkcs11/libopencryptoki.so

	# Remove compatibility symlinks as we _never_ required those and
	# they seem unused even upstream.
	find "${ED}" -name 'PKCS11_*' -delete || die

	# We replace their ld.so and init files (mostly designed for RedHat
	# as far as I can tell) with our own replacements.
	rm -r "${ED}"/etc/ld.so.conf.d "${ED}"/etc/rc.d || die

	# make sure that we don't modify the init script if the USE flags
	# are enabled for the needed services.
	cp "${FILESDIR}"/pkcsslotd.init.2 "${T}"/pkcsslotd.init || die
	use tpm || sed -i -e '/use tcsd/d' "${T}"/pkcsslotd.init
	newinitd "${T}/pkcsslotd.init" pkcsslotd

	# We create /var dirs at runtime as needed, so don't bother installing
	# our own.
	rm -r "${ED}"/var/{lib,lock} || die
}
