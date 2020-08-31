# frozen_string_literal: true

# Anliegen 120703 = ID card
module TerminDe
  # simple termin object to hold date and the link
  class Termin
    
    URL = 'https://service.berlin.de/terminvereinbarung/termin'
    ANLIEGEN = '120703'
    BURGERAMT_IDS = [
      # ALL '122210,122217,327316,122219,327312,122227,122231,327346,122238,122243,327348,122252,329742,122260,329745,122262,329748,122254,329751,122271,327278,122273,122277,327276,122280,327294,122282,327290,122284,327292,122291,327270,122285,327266,122286,327264,122296,327268,327262,325657,150230,329760,122301,327282,122297,327286,122294,327284,122312,329763,122304,327330,122311,327334,122309,327332,317869,324434,122281,327352,122279,122276,327324,122274,327326,122267,329766,122246,327318,122251,327320,327653,122257,327322,122208,122226'
      122_243, # Friedrichshain Frankfurter
      122_238, # Friedrichshain Schlesisches Tor
      122_260, # Lichtenberg Möllendorfstr
      122_262, # Lichtenberg TierparkCenter
    ]
    QUERY_URL = [
      'https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1',
      'dienstleisterlist=' + BURGERAMT_IDS.join(','),
      'anliegen[]=' + ANLIEGEN,
      'herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F' + ANLIEGEN + '%2F'
    ].join('&')

    attr_reader :date
    attr_reader :link

    def initialize(date:, link: '')
      @date = date
      @link = link
    end
  end
end
