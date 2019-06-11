# Projekt Anteckningar

## Databas

### Setup
1. Kåren säljer koder i caféet
2. En elev går sedan in på hemsidan och skapar ett konto med koden
    - Namn
    - Efternamn
    - Mail
    - Klass
    - Lösenord - Hashad
    - Kod
3. Elevkåren får skriva ner vem som köper vilken kod för att hålla koll på fusk.


### Tables
```
                        ######   users   ######
id, first-name, last-name, email, class, password, code, target-id, kills, score, alive
```

## Implementation
Inget offer kan ha mördaren som offer, det skapar en cirkel. Detta får endast
ske med de sista två personerna. Detta borde vara lätt att ordna. Vi organiserar
alla medlemmar en lång lista där varje person får den framför sig som offer och
den sista får den första. Detta borde bli en "cirkel" där enda sättet att få sig
själv är att döda hela cirkeln runt tills man kommer till den bakom sig.

## Regler
1. Varje person får ett off som man ska "döda"
2. Man "dödar" någon genom att nudde dem med det tilldelade vapnet
3. För att kunna döda någon måste man stå minst 3 meter ifrån dem, högt skriva
   "killer" och peka på dem innan man kan börja jaga sitt offer
4. Du måste hålla i vapnet när du dödar ditt offer, att kasta vapnet gäller inte
5. När du har dödat någon anger du detta i appen, de godkänner sedan att de har
   dött innan man får ett nytt offer
6. Man får 100 poäng per offer man dödat, de fem som har högst poäng syns på
   topplistan i appenoch hedras i slutet av tävlingen
7. Första veckan kommer man kunna "skydda" sig från att bli dödad genom att bära
   med sig en "sköld"
8. Sköldarna ändras varje dag, du kan se vilken som är aktuell varje dag genom
   att gå in på kårens instagram
9. Inget dödande får förekomma under lektioner eller under helger men efter
   skoltid är okej
10. Håll er på skolans områden: skolhuset, k-villan och områderna kring
    byggnaderna
11. Ej tillåtna platser: Inne i Foxes, på toaletter och i idrottslokalerna
12. Respektera varandra, var ärliga och ha roligt!


## Misc
Koden man får av elevkåren kan vara verifieringsmetoden om man har dödat någon.
Likt gfycat url-er kan den bestå av flera slumpade ord efter varandra. Då blir
det delvis svårare att skriva fel och så kan vi dubbelkolla att ingen
registrerar med en kostig kod.


