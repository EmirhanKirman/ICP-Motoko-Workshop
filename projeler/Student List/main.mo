import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor OgrenciListesi {

  type Ogrenci = {
    id : Nat;
    isim : Text;
    bolum : Text;
  };

  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var ogrenciler = Map.HashMap<Nat, Ogrenci>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public query func ogrencileriGetir() : async [(Nat, Ogrenci)] {
    Iter.toArray(ogrenciler.entries());
  };

  public shared (msg) func ogrenciEkle(isim : Text, bolum : Text) : async Text {
    let id = nextId;
    ogrenciler.put(id, { id = id; isim = isim; bolum = bolum });
    nextId += 1;
    "Öğrenci başarıyla eklendi. Öğrenci ID'si: " # Nat.toText(id);
  };

  public query func ogrenciGoruntule(id : Nat) : async ?Ogrenci {
    ogrenciler.get(id);
  };

  public func ogrencileriTemizle() : async () {
    for (key : Nat in ogrenciler.keys()) {
      ignore ogrenciler.remove(key);
    };
  };

  public shared (msg) func ogrenciGuncelle(id : Nat, yeniIsim : Text, yeniBolum : Text) : async Bool {
    switch (ogrenciler.get(id)) {
      case (?ogrenci) {
        ogrenciler.put(id, { id = id; isim = yeniIsim; bolum = yeniBolum });
        return true;
      };
      case null {
        return false;
      };
    };
  };

};
